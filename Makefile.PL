
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Business::Price',
                       'DISTNAME' => 'Business-Price',
                       'AUTHOR' => 'Moritz Onken <onken@netcubed.de>',
                       'ABSTRACT' => 'Handles prices with tax and discount',
                       'EXE_FILES' => [],
                       'VERSION' => '1.000_1',
                       'LICENSE' => 'bsd',
                       'PREREQ_PM' => {
                                        'MooseX::Types' => '0.21',
                                        'ExtUtils::MakeMaker' => '6.11',
                                        'Moose' => '0.98'
                                      }
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



