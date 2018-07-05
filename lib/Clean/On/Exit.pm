package Clean::On::Exit;
use Exporter qw(import);
use Scalar::Util qw(refaddr);
use Carp qw(confess);
use File::Spec;

our @EXPORT = qw/clean_on_exit wipe_on_exit/;

my %toClean;
sub clean_on_exit {
    return unless $#_ >= 0 and defined $_[0];
    my $r = ref $_[0];
    unless ( $r ) {
        my $pth2file = $#_ ? File::Spec->catfile(@_) : $_[0];
        return $pth2file if $toClean{'files'}{'paths'}{$pth2file};
        $toClean{'files'}{'paths'}{$pth2file} = ($toClean{'files'}{'index'}++ // 0);
    } elsif ($r eq 'CODE') {
        $toClean{'code'}{'pocs'}{refaddr $_[0]} //= [$toClean{'code'}{'index'}++ // 0, shift, \@_]
    } else {
        confess "Cant clean anything using reference of type <<$r>>, sorry :)"
    }
}

{
    no strict 'refs';
    *{__PACKAGE__ . '::wipe_on_exit'} = \&clean_on_exit
}

sub make_mrproper {
    if (%toClean) {
        if (%{$toClean{'files'}}) {
            my $paths = $toClean{'files'}{'paths'};
            unlink($_) for sort {$paths->{$a} <=> $paths->{$b}} keys $paths;
        }
        if (%{$toClean{'code'}}) {
            $_->[1]->(@{$_->[2]}) for sort {$a->[0] <=> $b->[0]} values $toClean{'code'}{'pocs'};
        }
    }
    %toClean = ()
}

for (qw/INT TERM/) {
    my $saveSIGHndl = $SIG{$_} // sub { exit 1 };
    $SIG{$_} = sub {
        make_mrproper;
        $saveSIGHndl->();
    }
}

END { make_mrproper }

1;
