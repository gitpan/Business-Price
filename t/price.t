use Test::More;

use Business::Price;

my @tests = (

);

ok( my $price = Business::Price->new( value => 1, tax => 0.2, incl => 0 ) );

is( $price->full, 1.2 );

is( $price->tax, 0.2 );

is( $price->net, 1 );

ok( my $price = Business::Price->new( value => 1.2, tax => 0.2, incl => 1 ) );

is( $price->full, 1.2 );

is( $price->tax, 0.2 );

is( $price->net, 1 );

ok( $price->discount(0.2) );

is( $price->net->discounted, 0.8 );

is( $price->net->discounted->discounted, 0.64 );

is( $price->full->discounted, 0.96 );

is( ++$price, 2.2 );

is( $price + 1, 3.2 );

is( $price + $price, 4.4 );

# examples from pod
{
    use Business::Price;
    my $price =
      Business::Price->new( value => 10, tax => 0.1, discount => 0.5 );
    is( $price->full,             11 );
    is( $price->full->discounted, 5.5 );
}

{
    my $price = Business::Price->new( value => 10 );
    ok( $price->isa('Business::Price') );
    is( $price,     10 );
    is( $price / 2, 5 );
}

{
    my $price = Business::Price->new( value => 1, discount => 0.5 );
    is( $price->discounted,             0.5 );
    is( $price->discounted->discounted, 0.25 );
}

{
    my $price = Business::Price->new(
        value    => 1,
        discount => sub {
            my ( $self, $is_reseller ) = @_;
            return $is_reseller ? $self / 2 : $self;
        }
    );
    is( $price->discounted(0), 1 );
    is( $price->discounted(1), 0.5 );
}

{
    my $price = Business::Price->new( value => 1, tax => 0.1 );
    is( $price->full, 1.1 );
}

{
    my $price = Business::Price->new( value => 1.1, tax => 0.1, incl => 1 );
    is( $price->net, 1 );
}
done_testing;
