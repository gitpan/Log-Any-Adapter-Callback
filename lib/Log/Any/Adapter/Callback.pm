package Log::Any::Adapter::Callback;
BEGIN {
  $Log::Any::Adapter::Callback::VERSION = '0.01';
}
# ABSTRACT: Send Log::Any logs to a subroutine

use 5.010;
use strict;
use warnings;

use Log::Any::Adapter::Util qw(make_method);
use base qw(Log::Any::Adapter::Base);

my ($logging_cb, $detection_cb);
sub init {
    my ($self) = @_;
    $logging_cb   = $self->{logging_cb}
        or die "Please provide logging_cb when initializing ".__PACKAGE__;
    if ($self->{detection_cb}) {
        $detection_cb = $self->{detection_cb};
    } else {
        $detection_cb = sub { 1 };
    }
}

for my $method (Log::Any->logging_methods()) {
    make_method($method, sub { $logging_cb->($method, @_) });
}

for my $method (Log::Any->detection_methods()) {
    make_method($method, sub { $detection_cb->($method, @_) });
}

1;


=pod

=head1 NAME

Log::Any::Adapter::Callback - Send Log::Any logs to a subroutine

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use Log::Any::Adapter;
 Log::Any::Adapter->set('Callback',
     logging_cb   => sub { ... },
     detection_cb => sub { ... }, # optional, default is: sub { 1 }
 );

=head1 DESCRIPTION

This adapter lets you specify callback subroutine to be called by Log::Any's
logging methods (like $log->debug(), $log->error(), etc) and detection methods
(like $log->is_warning(), $log->is_fatal(), etc.).

This is mostly a convenient construct and saves a few lines of code, because so
you don't have to create a full Log::Any adapter class.

Your logging callback subroutine will be called with these arguments:

 ($method, $self, $format, @params)

where $method is the name of method (like "debug") and ($self, $format, @params)
are given by Log::Any.

=for Pod::Coverage init

=head1 SEE ALSO

L<Log::Any>

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

