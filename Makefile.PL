use 5.008001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Posy::Plugin::Meta',
    VERSION_FROM      => 'lib/Posy/Plugin/Meta.pm', 
    PREREQ_PM         => {
                          Posy        => 0.92,
                          Posy::Core  => 0.92,
                          Test::More  => 0
                         }, 
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Posy/Plugin/Meta.pm', # retrieve abstract from module
       AUTHOR         => 'blair christensen. <blair@devclue.com>') : ()),
);
