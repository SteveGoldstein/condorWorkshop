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
my @outputFiles = grep {/^\d+\.\d+\.out$/} readdir D;
closedir D;

`mv @outputFiles outdir`;


__END__
