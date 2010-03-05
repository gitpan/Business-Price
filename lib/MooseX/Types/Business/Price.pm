package MooseX::Types::Business::Price;
our $VERSION = '1.000_1';

use MooseX::Types -declare => [qw(Price Tax Discount)];

use MooseX::Types::Moose qw/Num HashRef ArrayRef CodeRef/;

use Business::Price;

subtype Price,
    as 'Business::Price';

subtype Tax,
    as 'Num',
    where { $_ >= 0 && $_ < 1 },
    message { 'Taxes are defined as a number greater or equal 0 and smaller than 1' };

subtype Discount,
    as 'Num|CodeRef|ArrayRef',
    message { 'Specify either a number, code reference or array reference' };

coerce Price,
    from HashRef,
    via { Business::Price->new(%$_) };

1;
__END__
=pod

=head1 NAME

MooseX::Types::Business::Price

=head1 VERSION

version 1.000_1

=head1 AUTHOR

  Moritz Onken <onken@netcubed.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

