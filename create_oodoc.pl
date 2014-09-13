use Modern::Perl;
use OpenOffice::OODoc;
my $doc = odfDocument(
    file   => 'test.odt',  #’ test.odp’
    create => 'text' # for 'presentation‘ not
);
my $head = $doc->appendHeading(
    text  => "This is a Test",
    style => 'Heading 1');
my $style = $doc->createImageStyle("Photo");
my $image = $doc->createImageElement(
    'some picture',
    style      => 'Photo',
    attachment => $head,
    size       => '4cm, 12cm',
    link       => 'c:/TCPU59/utils/job/02072013/OpenOffice-OODoc-2.125/examples/dwim.jpg');
$doc->save();
