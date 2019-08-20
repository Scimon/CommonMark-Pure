use v6;

unit class CommonMark::Pure:ver<0.0.1>:auth<github:scimon>;

use CommonMark::Pure::MarkdownGrammar;
use CommonMark::Pure::MarkdownActions;

method to-html( Str $markdown is copy ) {
    if ( $markdown !~~ m!\n$! ) { $markdown ~= "\n" }
    my $actions = MarkdownActions.new;
    my $match = MarkdownGrammar.parse( $markdown, :$actions );
    return "{$actions.html}\n";
}


=begin pod

=head1 NAME

CommonMark::Pure - Non compiled Implementation of CommonMark spec.

=head1 SYNOPSIS

=begin code :lang<perl6>

use CommonMark::Pure;

=end code

=head1 DESCRIPTION

CommonMark::Pure is ...

=head1 AUTHOR

Simon Proctor <simon.proctor@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Simon Proctor

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
