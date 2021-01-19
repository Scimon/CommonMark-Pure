use v6;
use Test;
use CommonMark::Pure;

my $text-node = CommonMark::Pure::Text.new( :text("test") );
is $text-node.render, "test", "Basic Text Render works";

my $single-para = CommonMark::Pure::Node.new( :tag<p>, :content[CommonMark::Pure::Text.new( :text("test") )] );
is $single-para.render, "<p>test</p>", "Single Item Render works";

my $em-para = CommonMark::Pure::Node.new( :tag<p>,
					 :content[
						  CommonMark::Pure::Text.new( :text("test1 ") ),
						  CommonMark::Pure::Node.new(
						      :tag<em>,
						      :content[
							       CommonMark::Pure::Text.new( :text("test2") )
							   ]
						  ),
						  CommonMark::Pure::Text.new( :text(" test3") ),
					      ]
				       );
is $em-para.render, "<p>test1 <em>test2</em> test3</p>", "Nested Item Render works";

my $para2 = CommonMark::Pure::Node.new( :tag<p>, :content[CommonMark::Pure::Text.new( :text("test2") )] );

my ( $m1, $m2 ) = $single-para.merge( $para2 );

ok $m1 ~~ CommonMark::Pure::Node, "{$m1.perl} is a Node";
ok $m2 ~~ Any, "Merge occured";

is $m1.render, "<p>testtest2</p>", "Paragraph Merge OK";

done-testing;
