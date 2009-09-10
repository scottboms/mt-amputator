#!/usr/bin/perl -w

# Amputator: an ampersand-encoding plugin for Movable Type
# by Nat Irons
# http://bumppo.net
# Updated by Scott Boms to better support MT4 (also removed Blosxom support)
#
# Version 1.2.1
# 2009/09/09

package MT::Plugin::Amputator;
use strict;
use warnings;

require MT;
use base qw( MT::Plugin );

require MT::Template::Context;
use vars qw($VERSION);
our $VERSION = "1.2.1";

my $plugin = MT::Plugin::Amputator->new({
  id          => 'amputator',
  name        => 'Amputator',
  description => 'Converts stray ampersands to entity references, in the service of valid HTML.',
  author_name => 'Nathaniel Irons',
  author_link => 'http://www.bumppo.net/',
  doc_link    => 'http://www.bumppo.net/projects/amputator/',
  icon        => 'am-icon.gif',
  version     => $VERSION,
  registry    => {
      tags => {
        modifier => {
          'amputator' => \&amputator,
      },
    },
  },
});

MT->add_plugin($plugin);

sub encode_ampersands {
  my $html = shift;   # text to be parsed
  $html =~ s/&(?!#?[xX]?(?:[0-9a-fA-F]+|\w{1,8});)/&amp;/g;	
  return $html;
}

1;
__END__


=pod

=head1 Name

B<Amputator> 1.2.1 for Movable Type

=head1 Synopsis

 <mt:EntryBody encode_ampersands="1">

=head1 Short Description

Amputator is a free plugin for Movable Type. It safely rewrites ampersand characters as an HTML entity reference: "&amp;".

=head1 Long Description

If you want your HTML or XHTML to display smoothly across browsers and platforms, you need to use a little finesse with non-ASCII characters such as curly quotes, or "ä", or "™." On the web, I would have specified those last two characters by writing "&#xe4;" and "&#8482;." 

Sequences like "&#8482;" are called entity references, and their sole benefit is that they can be expressed in plain ASCII. HTML includes heaps of entity references to stand in for various accented and otherwise special characters not found in ASCII. Entity references all start with ampersands, and end with semicolons.

Unfortunately, X/HTML reserves the ampersand exclusively for entity references. Any time you use an ampersand by itself in HTML, for example, within the token delimiters of GET-style URLs, the parser will interpret it like the start of a nonexistent entity reference. Any decent browser will catch the error and recover, but it's still a mistake, and your HTML won't validate.

You can make your HTML clean again by replacing any ampersands with the entity reference for an ampersand. So instead of just "&", you'd write "&amp;", and the browser will make the last-minute substitution.

Amputator steps in to relieve you of the crushing, trivial burden of replacing all those ampersands yourself. After installation into Movable Type or Blosxom, you can freely gab about Law & Order and Brown & Williamson, and your ampersands will be replaced by entity references on the fly, as you publish.

Of course, Amputator is smart enough to ignore ampersands attached to existing entities. Otherwise, writing "&eacute;" would become "&amp;eacute;", and nobody likes that except the odd technical writer.

=head1 Movable Type Installation

Amputator requires Movable Type version MT 4.x and newer.

=over 4

=item 1.

Copy the Amputator folder into your Movable Type plugins directory. If you don't have a plugins directory, create an empty directory named "plugins" in your MT server root, alongside all the MT CGIs, and put Amputator inside that new directory. In other words, your installation should look like this:

  (MT home)/plugins/Amputator
 
=item 2.

Now it's time to edit your blog templates. Any tags that might contain a stray ampersand should be modified to call encode_ampersands. mt:EntryBody is an obvious place to start:

  <mt:EntryBody>

becomes

  <mt:EntryBody encode_ampersands="1">

Easy! Ditto for mt:EntryMore, or  mt:EntryTitle:

  <mt:EntryMore encode_ampersands="1">
  <mt:EntryTitle encode_ampersands="1">

You're done.

=back

=head1 Bugs

I know of only one case where Amputator improperly replaces an ampersand: if you're using a JavaScript snippet inside of a weblog entry, Amputator may convert an ampersand intended for the JavaScript interpreter instead of the browser, confusing the interpreter. If this problem affects you, please let me know at the address below so we can discuss a solution.

Aside from that, if you encounter a problem, please send me a note and tell me all about it.

    ndi-amputator@bumppo.net

=head1 See Also

    http://daringfireball.net/projects/smartypants/

=head1 Version History

=over 4

=item *

1.2.1 Wednesday, September 9, 2009

Updated for Movable Type 4.x and newer and removed Blosxom support.

=item *

1.2 Friday, August 26, 2005

Now compatible with Movable Type 3.2, as well as earlier versions.

Blosxom already encodes ampersands when producing RSS, so Amputator leaves Blosxom's RSS output alone. I also abandoned the cleaner MT::Plugin namespace, because Blosxom couldn't handle it.

Amputator now officially supports MT's dynamic publishing model (thanks, Chad Everett).

=item *

1.1.1 Mon, Feb 21, 2005

No functional code changes, but Amputator now declares itself to MT 3 installations on the main menu page, and uses the sanctioned MT::Plugin::Amputator package instead of the Amputator package. Existing users should feel no pressure to upgrade unless they enjoy looking at the plugin census.

Also uses the MT::Plugin::Amputator package, instead of just Amputator.

=item *

1.1 Tue, March 16, 2004

Updated for Blosxom support.

=item *

1.0: Thu, March 6, 2003

Initial release.

Documentation revised September 28, 2003.

=back

=head1 Author

  Nat Irons
  http://bumppo.net

=head1 Additional Credits

John Gruber (http://daringfireball.net) precipitated the release of this plugin by providing several good reasons why he was unwilling to make SmartyPants take care if it for me.

Max Barry (http://maxbarry.com), whose novel "Jennifer Government" I quite enjoyed, suggested adding Blosxom support, and proposed the mechanism to exclude ampersand encoding from RSS output (when Blosxom handles the encoding by itself).

Grettir Asmundarson and Chad Everett contributed code.

=head1 Copyright and License

Copyright (c) 2005 Nathaniel Irons. All rights reserved. This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
