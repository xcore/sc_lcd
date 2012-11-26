#!/usr/bin/perl

$numberOfArgs = @ARGV;

if( @ARGV < 1) # is less than two arguments
{    
  print "usage: generate.pl lcd width in pixels";
  exit 0;
}

$buf_length = $ARGV[0];

open(OUTFILE,">lcd_generated.inc");
for($i = 1; $i < $buf_length/2; $i++) {
	print OUTFILE "  ldw r0, cp[$i]\n";
	print OUTFILE "  out res[r2], r0\n";
	print OUTFILE "  shr r0, r0, 16\n";
	print OUTFILE "  out res[r2], r0\n";
}
close(OUTFILE);

