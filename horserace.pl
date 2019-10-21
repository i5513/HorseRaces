#!/usr/bin/perl -w
use strict;

my $nhorses=10;
my $finished=AnyEvent->condvar;

require Term::Screen;
use AnyEvent;

sub status
{
	my ($scr,$string) = @_;
	$scr->at ($nhorses,0)->clreol->reverse->bold->puts ("$string")->normal;
}

sub next_step
{
	my ($scr,$horses) = @_;
	my $max_jump=4;
	
	foreach my $horse (keys %$horses)
	{
		my $step=int(rand($max_jump)); $horses->{$horse}+=$step;
		if ($step == $max_jump-1 and (int (rand (20)) == 19))
		{
			$horses->{$horse}+=$max_jump-1;
			status $scr, "Wowwww $horse went to infinity!!";
		}
	}

	if (int(rand(10)) == 9)
	{
		status $scr,  "Horses delayed: ". join (",", 
				((sort {$horses->{$a} <=> $horses->{$b}}
					keys %$horses)[0..2]));
	}
}

sub draw_horses
{
	my ($scr,$horses) = @_;
	$scr-> at ( $_-1,$horses->{$_}-length $horses->{$_}+1)->puts($_) 
		foreach sort { $a <=> $b } keys %$horses;
}

sub draw_end
{
	my ($scr,$horses) = @_;
	$scr-> at ( $_-1,49)->puts("|") foreach keys %$horses;
}

sub clean_horses
{
	my ($scr,$horses) = @_;
	$scr-> at ( $_-1, $horses->{$_}-length $horses->{$_}+1)
		-> puts(" " x length $_) foreach sort { $a <=> $b } keys %$horses;
}

sub race_finished
{
	my ($scr,$horses) = @_;
	my @winers = grep {$horses->{$_} > 50} (keys %$horses);

	if (scalar @winers > 0)
	{
		status $scr, "And the winner is: ".
			$winers[int(rand(scalar @winers))]."\r\n";
		return 1;
	}
	return 0;
}

sub init_screen
{
	my ($horses) = @_;
	my $scr = new Term::Screen;
	unless ($scr) { die "Something's wrong\n"; }
	$scr->clrscr();	system ("stty isig"); system ("tput civis");
	draw_horses ($scr,$horses); draw_end ($scr, $horses);
	status $scr, "Ready ..."; sleep 1; status $scr, "Stady ..."; sleep 1;
	status $scr, "Go! ..."; 
	return $scr;
}

sub update_screen
{
	my ($scr,$horses) = @_;
	clean_horses ($scr,$horses);
	next_step ($scr,$horses);
	draw_horses ($scr, $horses);
	$finished -> send if (scalar race_finished($scr,$horses));
}

my $w = AnyEvent->signal (signal => "INT", cb => 
	sub { system("tput cvvis"); print "Finished before the end\n"; exit 1 });
my %horses= map { $_ => 0 } (1..$nhorses);
my $scr=init_screen (\%horses);
my $hr = AnyEvent->timer (after => 2, interval => 1, 
		cb => sub {update_screen ($scr,\%horses); });
$finished->recv;
