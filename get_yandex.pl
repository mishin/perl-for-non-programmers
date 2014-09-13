use Modern::Perl;
use charnames ':full';
binmode( STDOUT, ":utf8" );
use WWW::Mechanize::Firefox;
use URI::Split qw( uri_split uri_join );
use Try::Tiny;

my $url  = 'http://yandex.ru/';
my $stop = 10;
backup_url_from_page( $url, $stop );

sub backup_url_from_page {
    my ( $url, $stop ) = @_;
    my $mech = WWW::Mechanize::Firefox->new( tab => 'current', );
    $mech->get($url);
    sleep 4;

    my $collection = collect_all_links_tag($mech);

    while ( my ( $file_name, $url ) = each( %{$collection} ) ) {
        try {
            $mech->get($url);
            $mech->save_content( $file_name, $file_name . 'files' );
            say "url $url successfully saved in $file_name";
        }
        catch {
            warn "caught error: $_ url \n $url not saved in file $file_name";
        };
        last if --$stop == 0;
    }

}

sub collect_all_links_tag {
    my $mech = shift;
    my %collection;

    for ( $mech->selector('a') ) {
        my $name = $_->{innerHTML};
        my $href = $_->{href};
        my ( $scheme, $auth, $path, $query, $frag ) = uri_split($href);
        $path =~ s{/}{_}g;
        if ( $path !~ /.*[.](htm|html)$/i ) {
            $path = $path . ".html";
        }
        $collection{$path} = $href;
    }
    return ( \%collection );
}
