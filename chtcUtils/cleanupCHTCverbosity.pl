#!/usr/bin/perl -w


use strict;
use Carp;
use English;
use Getopt::Long;
use Cwd;

GetOptions (

            );

my $chtcNoise = "./chtcOutput";
croak "$chtcNoise directory already exists." 
    if ( -e $chtcNoise);

croak "Can't create $chtcNoise directory" 
    unless (mkdir $chtcNoise);

## Get the $(CLUSTER) value from a ChtcWrapper file;
opendir D, "." or croak "Can't read directory";
my $ChtcWrapperFile = (grep {/^ChtcWrapper\d+\.\d+.out$/} readdir D)[0];
closedir D;
(my $clusterID) = $ChtcWrapperFile =~ /^ChtcWrapper(\d+)\.\d+.out/; 
if (not $clusterID) {
    carp 'Can\'t find any files matching ChtcWrapper$(CLUSTER).$(PROCESS).out';
}

my @filelist = 
    qw 
    (
     ChtcWrapper*out
     AuditLog*
     CURLTIME*
     outdir/*
     queue/error/*
     DONE
     harvest.log
     CODEBLOWUP
    );

foreach my $fileSpec (@filelist) {
    `mv $fileSpec $chtcNoise 2> /dev/null`;
}

opendir D, "." or croak "Can't read directory";
my @outputFiles;
@outputFiles = grep {/$clusterID\.\d+/} readdir D
    if ($clusterID);
    
closedir D;

`mv @outputFiles outdir`
    if (@outputFiles);


__END__
