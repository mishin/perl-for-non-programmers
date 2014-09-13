#!perl
use Modern::Perl;
use POSIX qw(strftime);
use File::Slurp;
use File::Path qw(make_path);
use File::Spec::Functions qw(catdir catfile);
use File::HomeDir;

main();

# Make path tree and file
sub main {
    my $work_path = File::HomeDir->my_documents;
    my $date      = strftime( '%d%m%Y', localtime(time) );
    my $job_dir   = catdir( $work_path, 'job', $date );
    make_path($job_dir);    # if !-d $job_dir;

    my $file = catfile( $job_dir, $date . '_nb.txt' );
    write_file($file) if !-f $file;#     write_file( $file, { no_clobber => 1, err_mode => 'quiet' }, '' );
    say "file $file written successfully!";
}
