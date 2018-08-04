use Net::DNS;
use NetAddr::IP;
use Data::Printer;
my $res = Net::DNS::Resolver->new;

# create the reverse lookup DNS name (note that the octets in the IP address need to be reversed).
my $IP = "2001:4860:4860::8888";
my $ip = NetAddr::IP->new($IP);
my $full = $ip->full;
$full=~s/\://g;
print "$full\n";

my $target_IP = join('.', reverse split(//, $full)).".ip6.arpa";
#$target_IP = "9.4.7.9.2.e.2.2.0.f.4.8.8.9.b.5.0.0.0.0.4.b.5.f.4.4.6.4.1.0.0.2.in-addr.arpa";
print "$target_IP\n";

my $query = $res->query("$target_IP", "PTR");

if ($query) {
  foreach my $rr ($query->answer) {
    next unless $rr->type eq "PTR";
    print $rr->rdatastr, "\n";
    p $rr;
  }
} else {
  warn "query failed: ", $res->errorstring, "\n";
}
