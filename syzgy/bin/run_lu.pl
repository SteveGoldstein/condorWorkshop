#!/usr/bin/perl -w

use strict;
use Carp;
use English;
use Getopt::Long;
use Cwd;

my $pivot = 'TPP';
my $nzinit = '1e7';
my $start = 1;
my $end;
my $redoList;
my $qr = 0;
my $datDir = 'test_6_3/matricies/map_6_0';
my $baseOutdir = 'outdir';  ## default prefix for output dirs;

GetOptions (
    'start=i'      => \$start,
    'end=i'        => \$end,
    'nzinit=s'     => \$nzinit,
    'redoList=s'   => \$redoList,
    'qr!'          => \$qr,
    'datDir=s'     => \$datDir,
    'baseOutdir=s' => \$baseOutdir,
            );

my %redo = ();
if (defined $redoList) {
    open REDO, $redoList or croak "Can't open $redoList";
    while(<REDO>) {
	chomp;
	next if /^#/;
	next if /^\s*$/;
	$redo{$_} = 1;
    }
    close REDO;
}

opendir DATFILES, $datDir;

my @datFiles = grep {/\.dat$/} readdir DATFILES;
closedir DATFILES;

my @dataFiles2Process;
foreach my $file (@datFiles) {
    if (scalar keys %redo) {
	next unless (exists $redo{$file});
    }

    push @dataFiles2Process, $file;
}

map {$_ = "$datDir/$_"} @dataFiles2Process;
@dataFiles2Process = sort @dataFiles2Process;
if (not defined $end) {
    $end = scalar @dataFiles2Process;
}

## set up environment;
$ENV{LD_LIBRARY_PATH} = '/usr/local/matlab/runtime/glnxa64:/usr/local/matlab/bin/glnxa64:/usr/local/matlab/sys/os/glnxa64:/usr/local/matlab/sys/opengl/lib/glnxa64';

(my $mapID =$datDir) =~ s%^.*/(map_\d+_\d+)/?$%$1%;

my $outdir = "${baseOutdir}_$mapID.$start-${end}_$PID";

my $errdir = "$outdir/error";
mkdir $outdir;
mkdir $errdir;


foreach my $datFile (@dataFiles2Process[$start-1..$end-1]) {
    next if (-z $datFile);
    (my $baseName = $datFile) =~ s%^.*/%%;
    $baseName =~ s/\.dat$//;

    my $cmd;
    if (not $qr) {
	$cmd = "nohup ./exe/final_lu $datFile $outdir/$baseName.$pivot.$nzinit.txt $nzinit $pivot 1> $outdir/$baseName.$pivot.$nzinit.out 2> $errdir/$baseName.$pivot.$nzinit.err &";
    }
    else {
	$cmd = "nohup ./exe/final_qr $datFile $outdir/$baseName.qr.txt 1> $outdir/$baseName.qr.out 2> $errdir/$baseName.qr.err &";
    }
    print `$cmd`;
    sleep 2;
}
 
__END__

 
 /usr/local/matlab/bin/mcc -m -R -singleCompThread -R -nodisplay -R -nojvm -d exe -a lusol/matlab bin/final_lu.m
/usr/local/matlab/bin/mcc -m -R -singleCompThread -R -nodisplay -R -nojvm -d exe bin/final_qr.m 

to run, either use run_final_{lu,qr}  or     
  for f in `cat toTry.list`; do g=${f/#*\//outdir/}; g=${g/%dat/out} ; h=${g/%out/err};  nohup ./final_lu $f 1> $g 2>$h & done
for f in `cat toTry.list`; do g=${f/#*\//outdirTPP_1/}; g=${g/%dat/out} ; h=${g/%out/err};  nohup matlab -nodesktop -nosplash -nojvm -nodisplay -r "addpath('./bin'); final_lu $f TPP" 1> $g 2> $h &  done
