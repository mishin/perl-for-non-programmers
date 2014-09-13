use v6;
BEGIN { @*INC.push( 'c:\Users\TOSH\Desktop\TCPU59\scripts\lib' );}
use File::HomeDir;
use File::Spec;
use DateTime::Format;
# use File::Directory::Tree; 
main();
 
sub main {
my $work_path = File::HomeDir.my_home;
my $date      = strftime( '%d%m%Y', DateTime.new(now) );
my $job_dir   = File::Spec.catdir( $work_path, 'job', $date );
say $job_dir;
# mktree($job_dir);
# system ("mkdir $job_dir");
run "mkdir $job_dir";
my $file = File::Spec.catfile( $job_dir, $date ~'_nb.txt' );
 if (my $fh = open $file, :w) {
        $fh.say("hello world");
     }
}