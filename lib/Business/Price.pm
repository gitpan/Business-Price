package Business::Price;
our $VERSION = '1.000_1';

# ABSTRACT: Handles prices with tax and discount

use Moose;
use MooseX::Types::Business::Price q(:all);

has discount => ( is => 'rw', isa => Discount, default => 0 );

has value => ( is => 'rw', isa => 'Num', required => 1 );

has tax => ( is => 'rw', isa => Tax, default => 0 );

has incl => ( is => 'rw', isa => 'Bool', default => 0 );

use overload
  '""' => sub { shift->value },
  '='  => sub { shift->clone },
  '+'  => sub {
    my $self = shift;
    return $self->clone( value => $self->value + $_[0] );
  },
  '-' => sub {
    my $self = shift;
    return $self->clone( value => $self->value - $_[0] );
  },
  '*' => sub {
    my $self = shift;
    return $self->clone( value => $self->value * $_[0] );
  },
  '/' => sub {
    my $self = shift;
    return $self->clone( value => $self->value / $_[0] );
  },
  '%' => sub {
    my $self = shift;
    return $self->clone( value => $self->value % $_[0] );
  },
  '**' => sub {
    my $self = shift;
    return $self->clone( value => $self->value**$_[0] );
  },
  '<<' => sub {
    my $self = shift;
    return $self->clone( value => $self->value << $_[0] );
  },
  '>>' => sub {
    my $self = shift;
    return $self->clone( value => $self->value >> $_[0] );
  },
  'x' => sub {
    my $self = shift;
    return $self->clone( value => $self->value x $_[0] );
  },
  '<=>' => sub {
    return shift->value <=> $_[0];
  },
  'cmp' => sub {
    return shift->value cmp $_[0];
  };

sub discounted {
    my ( $self, @args ) = @_;
    my $discount = $self->discount;
    if ( !ref $self->discount ) {
        return $self->clone( value => $self->value * ( 1 - $self->discount ) );
    }
    elsif ( ref $self->discount eq 'CODE' ) {
        return $self->discount->( $self, @args );
    }
}

sub full {
    my $self = shift;
    unless ( $self->incl ) {
        return $self->clone(
            value => $self->value * ( 1 + $self->tax ),
            incl => 1
        );
    }
    return $self->clone;
}

sub net {
    my $self = shift;
    if ( $self->incl ) {
        return $self->clone(
            value => $self->value / ( 1 + $self->tax ),
            incl => 0
        );
    }
    return $self->clone;
}

sub clone {
    my $self = shift;
    return bless( { %$self, @_ }, ref $self );
}

__PACKAGE__->meta->make_immutable;


=pod

=head1 NAME

Business::Price - Handles prices with tax and discount

=head1 VERSION

version 1.000_1

=head1 SYNOPSIS

 use Business::Price;
 my $price = Business::Price->new( value => 10, tax => 0.1, discount => 0.5 );
 is( $price->full, 11 );
 is( $price->full->discounted, 5.5 );

=head1 ATTRIBUTES

=head2 value ( Num )

Required

The object stringifies to this attribute.

=head2 discount ( Num | ArrayRef | HashRef | CodeRef )

Default: 0

=head2 tax ( Num )

Default: 0

Defines the tax rate. Valid values are from 0 to 1 (excluded).

=head2 incl ( Bool )

Default: 0

Specifies whether L<value|/value ( Num )> includes tax or not.

=head1 METHODS

Methods will always return a new L<Business::Price> object.
It stringifies to L<value|/value ( Num )> and you can do math on those object
since it uses L<overload>.

  my $price = Business::Price->new( value => 10 ); 
  ok( $price->isa('Business::Price') );
  is( $price, 10 );
  is( $price / 2, 5 );

=head2 net

Returns an object with the net price applied (i.e. without tax).

 my $price = Business::Price->new( value => 1.1, tax => 0.1, incl => 1); 
 is( $price->net, 1 );

=head2 full

Returns an object with the full price applied (i.e. tax applied).

 my $price = Business::Price->new( value => 1, tax => 0.1 ); 
 is( $price->full, 1.1 );

=head2 discounted ( Any )

Discount the price by the format defined in L<discount|/discount ( Num | ArrayRef | HashRef | CodeRef )>.

 my $price = Business::Price->new( value => 1, discount => 0.5 );
 is( $price->discounted, 0.5 );
 is( $price->discounted->discounted, 0.25 );


 my $price = Business::Price->new(
     value    => 1,
     discount => sub {
         my ( $self, $is_reseller ) = @_;
         return $is_reseller ? $self / 2 : $self;
     }
 );
 is( $price->discounted(0), 1 );
 is( $price->discounted(1), 0.5 );

=head2 clone ( Hash )

Clone the object. Any parameters overwrite the object's L<attributes|/ATTRIBUTES>.

  my $price_excl = Business::Price->new( value => 1, incl => 0 );
  my $price_incl = $price->clone( incl => 1 );

=head1 SEE ALSO

L<Business::Tax::Canada>, L<Business::Tax::VAT>, L<Moose>

=head1 AUTHOR

  Moritz Onken <onken@netcubed.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut


__END__

