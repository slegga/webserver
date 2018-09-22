#!/usr/bin/env perl
use Mojo::Base -strict;
use utf8;
binmode STDOUT, ':utf8';
#use Encode::Locale;

my $rekord = 0;


while (1) {
	say "\nLykke til\n";
	my $i=1;
	my $poeng = 1;
	my $start = time;
	
	while ( $i<=10 && $poeng > 0) {
		my $tall1 = int(rand(10)+10);
		my $tall2 = int(rand(8)+2);
        my $svar='';
		while ($svar !~/\d/ || $svar != ($tall1 - $tall2)) {
            $start -= 10 if ($svar ne '');
            printf "%d)  %d - %d = ",$i,$tall1,$tall2;
			$svar = <STDIN>;
			chomp($svar);
			#say "$svar != ($tall1 - $tall2)";
			exit if ($svar eq 'q');
            $poeng = $start - time + 100;
		}
		$poeng = $start - time + 100;
		say "Rest tid: ".$poeng."\n";
		$i++;
	}
	$poeng = $start - time + 100;
	if ($poeng>0) {
        say "\nBra! Du fikk $poeng poeng";
    } else {
        say"Det gikk ikke";
    }
	if ($rekord < $poeng) {
		say "\nNy rekord!";
		$rekord = $poeng;
	}
	print "\nLinje skift for ny runde (e) for å gå ut ";
	my $svar = <STDIN>;
	chomp($svar);
	exit if $svar eq 'e';
}
