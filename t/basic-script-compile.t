# script_compile.t
# use lib "$ENV{HOME}/git/utilities-perl/lib"; should be in script and not here
use Test::Compile 'no_plan';
for my $script (glob('script/*'),glob('bin/*')) { #$FindBin::Bin . '/../
    next if -d $script;
    if ( $script =~ /\.pl$/ || $script =~ /^[^\.]+$/) {
        pl_file_ok( $script );
    }
}
