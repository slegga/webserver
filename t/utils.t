use Test::More;
use MyApp::Utils qw( cr2br );
my $text="Hei\npå\ndeg\n";
is (cr2br($text),'Hei<BR>på<BR>deg<BR>');
done_testing;
