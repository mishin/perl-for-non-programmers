use Modern::Perl;
use Readonly;
use PDF::API2;
use List::Util qw(max);
use DDP;    # p for debug

# Размер бумаги A4
Readonly my $PAGE_WIDTH  => 360;    #210;
Readonly my $PAGE_HEIGHT => 200;    #297;

# Внутренняя единица измерения PDF::API2 - пункты
Readonly my $ONE_MILLIMETER_IN_POINTS => 72 / 25.4;

# Перевод миллиметров в типографские пункты
sub _mm_to_pt {
    my $mm = shift;
    return $mm * $ONE_MILLIMETER_IN_POINTS;
}

my $pdf = PDF::API2->new( -file => 'new2.pdf' );
my $message = '
Perl для не программистов
для ленивых
для путешественников
для не трудоголиков
для тех, кто не любит кодить
кто хочет работать 1 час в день;))';

add_text( $pdf, $message );
add_text( $pdf, 'А это я с Лари Уоллом!' );
add_image($pdf);

$pdf->save();

sub add_text {
    my ( $pdf, $message ) = @_;
    my $page = $pdf->page();
    add_rectangle($page);
    $page->mediabox( _mm_to_pt($PAGE_WIDTH), _mm_to_pt($PAGE_HEIGHT) );

    my $font = $pdf->ttfont( 'C:\WINDOWS\Fonts\Arial.ttf', -encode => 'utf8' );

    my $text = $page->text();
    $text->font( $font, 54 );
    $text->fillcolor('white');
    my @lines = split( /\n/, $message );

    ( scalar @lines == 1 )
      ? show_line_in_center( $text, $lines[0] )
      : show_multyple_line( $text, \@lines );
}

sub show_line_in_center {
    my ( $text, $line ) = @_;
    $text->translate( _mm_to_pt( $PAGE_WIDTH / 2 ),
        _mm_to_pt( $PAGE_HEIGHT / 2 ) );    #текст по центру
    $text->text_center($line);

}

sub show_multyple_line {
    my ( $text, $lines ) = @_;
    my $max_length = max( map { length } @$lines );
    my $i = 0;
    for my $line (@$lines) {
        $text->translate(
            150 + _mm_to_pt( int( ( $max_length - length $line ) / 2 ) ),
            500 - 60 * $i++ );
        $text->text($line);
    }
}

sub add_image {
    my $pdf = shift;
    my $jpgname =
'c:/TCPU59/utils/job/02072013/OpenOffice-OODoc-2.125/examples/larry_and_i.JPG ';
    my $image  = $pdf->image_jpeg($jpgname);
    my $width  = $image->width();
    my $height = $image->height();

    # Set the page size to equal the image size
    my $page = $pdf->page();
    $page->mediabox( $width, $height );

    # Place the image in the bottom corner of the page
    my $gfx = $page->gfx();
    $gfx->image( $image, 0, 0 );
}

sub add_rectangle {
    my $page      = shift;
    my $black_box = $page->gfx;
    $black_box->fillcolor('black');
    $black_box->rect( 0, 0, 1395, 1400 );
    $black_box->fill;
}
