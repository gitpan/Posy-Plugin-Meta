package Posy::Plugin::Meta;

#
# $Id: Meta.pm,v 1.3 2005/03/04 03:40:21 blair Exp $
#

use 5.008001;
use strict;
use warnings;

=head1 NAME

Posy::Plugin::Meta - Insert arbitrary metadata into an entry

=head1 VERSION

This document describes Posy::Plugin::Meta version B<0.1>.

=cut

our $VERSION = '0.1';

=head1 SYNOPSIS

  @plugins = qw(
    Posy::Core
    ...
    Posy::Plugin::Meta
  );
  @entry_actions = qw(header
    ...
    parse_entry
    parse_meta
    render_entry
    ...
  );

=head1 DESCRIPTION

This module allows one to insert arbitrary metadata into one's entry
files that can be consumed by other plugins.

This module currently assumes a very particular structure about one's
entry files.  Given an entry of the following structure:

  The Entry's Title
  <!--
  meta-via: blair christensen.
  meta-links: http://devclue.com/ http://search.cpan.org/
  -->
  The rest of the entry is down here.

Everything between "<!--" and "-->" will be removed from the entry's
body after being processed by "parse_meta".  In addition, the following
variables will be set:

  $current_entry->{meta}{via} = "blair christensen.";
  $current_entry->{meta}{links} = "http://devclue.com/ http://search.cpan.org/"

=head1 INTERFACE

=head2 parse_meta()

  $self->parse_meta($flow_state, $current_entry, $entry_state)

Alters $current_entry->{body} by removing metadata and populating the
metadata namespace of the current entry.

=cut
sub parse_meta {
  my ($self, $flow_state, $current_entry, $entry_state) = @_;
  my $body = $current_entry->{body};
  if ($body) {
    # 'Tis easier to work with as an array
    my @body = split "\n", $body;
    if ($body[1] =~ /^<!--/o and $body[2] =~ /^meta\-/o) {
      # We've got meta content.  Extract it.
      my $new = shift @body; # Save the first, pre-meta, line
      shift @body; # Remove the open comment
      my $out = undef;
      for my $l (@body) {
        if (defined $out) {
          $new .= "$l\n"; # Done with metadata.  Append other content.
        } elsif ($l =~ /^meta-(\S+):\s*(.+)$/o) {
          # Make sure it isn't just whitespace
          next if ($2 =~ /^\s*$/);
          $current_entry->{meta}{ $1 } = $2;
        } elsif ($l =~ /^\-{2}>/o) {
          # Thus endeth the metadata
          $out++;
        }
      }
      $current_entry->{body} = $new;
    }
  }
  1;
} # parse_meta()

=head1 SEE ALSO

L<Perl>, L<Posy>

=head1 AUTHOR

blair christensen., E<lt>blair@devclue.comE<gt>

<http://devclue.com/blog/code/posy/Posy::Plugin::Meta/>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by blair christensen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 DISCLAIMER OF WARRANTY                                                                                               

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE
LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS
AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES
OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH DAMAGES.

=cut

1;

