use strict;

package Tree;
sub new {
    my $class = shift;
    $class = ref $class if ref $class;
    my $root = {
            left_child => undef,
            right_child=> undef,
            parent => undef,
            data=> undef,
    };
    bless ($root,$class);
    return $root;
}

sub node {
    my $data = shift;
    my %node = (
        left_child=>undef,
        right_child=>undef,
        data=>$data,
        parent=>undef,
    );
    return %node;
}
sub add_node {
    my ($self,$data) = @_;
    my %node = &node($data);
    if (!$$self{data}) {
        $$self{data} = $data;
        print "root_add成功\n";
    }
    else
    {
        #插入到当前结点(root)的左孩子
        if (!$$self{left_child} && $$self{data} > $data) 
        {
            $node{parent} = $self;
            $$self{left_child} = \%node;
            print "left_add成功\n";
            return;
        }
        #//插入到当前结点(root)的右孩子
        if (!$$self{right_child} && $$self{data} < $data) 
        {
            $node{parent} = $self;
            $$self{right_child} = \%node;                       
            print "right_add成功\n";
            return;
        }
        if ($$self{data} > $data) 
        {
            &add_node($$self{left_child},$data);
        }
        elsif($$self{data} < $data)
        {
            &add_node($$self{right_child},$data);
        }
        else
        {
            return;
        }
    }

}
sub print_tree {
    my $tree = shift;
    if($$tree{data})
    {
        if ($$tree{left_child})
        {
            &print_tree($$tree{left_child});
        }
        print "$$tree{data}";
        if ($$tree{right_child})
        {
            &print_tree($$tree{right_child});
        }
    }
}
sub search {
    my ($root,$data) = @_;
    if (!$$root{data}) 
    {
        print "undef\n";
        return undef;
    }
    if ($data > $$root{data}) 
    {
        return &search($$root{right_child},$data);
    }
    elsif ($data < $$root{data})
    {
        return &search($$root{left_child},$data);
    }
    else
    {
        print "search succeed!\n";
        return $root;
    }
}
sub search_min 
{
    my $head = shift;
    if (!$$head{data}) {
        
        return undef;
    }
    while ($$head{left_child}) {
        $head = $$head{left_child};
    }
   # print "min = $$head{data}\n";
    return $head;
}
sub search_max {
    my $head = shift;
    if(!$$head{data})
    {
        return undef;
    } 
    if(!$$head{right_child})
    {
        return $head;
    }
    else
    {
        #一直往右孩子找，直到没有右孩子的结点
        return &search_max($$head{right_child});
    }
}
sub search_parent {
    my $node = shift;
    if (!$$node{data}) {
        print "xxx\n";
        return $node;
    }
    if ($$node{left_child}) 
    {
        print "zzzz\n";
        return &search_max($$node{left_child})
    }
    else
    {
        if (!$$node{parent}->{data}) {
            return undef;
        }
        while ($$node{data}) 
        {
            if ($$node{parent}->{right_child}->{data} eq $$node{data}) 
            {
                last;
            }
            $node = $$node{parent};
        }
        return $$node{parent};
    }
}
sub search_child {
    my $child = shift;
    if (!$child) {
        return $child;
    }
    if ($child->{right_child}) 
    {
        return &search_min($child->{right_child});
    }
    else
    {
        if (!$child->{parent}) 
        {
            return undef;
        }
        while ($child) 
        {
            if($child->{parent}->{left_child} == $child) 
            {
                last;
            }
            $child = $$child{parent};
        }
        return $$child{parent};
    }
}
sub delete {
    my ($tree,$data) = @_;
    my $node = &search($tree,$data);
    if ($$node{left_child}->{data} eq undef && $$node{right_child}->{data} eq undef) 
    {#叶节点的删除

        if (!$node->{parent}) 
        {
            print "This tree is undef\n";        
            $node = undef;
            $tree = undef;
        }
        else
        {
            my $parent = $node->{parent};
            if ($node->{parent}->{left_child} eq $node) 
            {    
                $node->{parent}->{left_child} = undef;
                print "delete!!\n";
            }
            else
            {
                $node->{parent}->{right_child} = undef;
                print "delete!!\n";
            }
        }
    }
    elsif($$node{left_child} && !$$node{right_child}) 
    {#删除仅有个单儿子的非叶子节点(只有左儿子)
        
        $node->{left_child}->{parent} = $node->{parent};
        #如果删除的是父亲节点
        if (!$node->{parent}) 
        {
            $$tree{root} = $node->{left_child};
            $$tree{data} = $node->{right_child}->{data};
        }
        #如果删除的节点是父亲节点的左儿子
        elsif ($node->{parent}->{left_child}->{data} == $node->{data})
        {
            $node->{parent}->{left_child} = $node->{left_child};
        }
        #如果删除的节点是父亲节点的右儿子
        else
        {
            $node->{parent}->{right_child} = $node->{left_child};
        }
    }
    elsif($$node{right_child} && !$$node{left_child})
    {#删除仅有个单儿子的非叶子节点(只有右儿子)

        $node->{right_child}->{parent} = $node->{parent};
        #如果删除的是父亲节点
        if (!$node->{parent}) 
        {
            $$tree{root} = $node->{right_child};
            $$tree{data} = $node->{right_child}->{data};
        }
        #如果删除的节点是父亲节点的左儿子
        elsif ($node->{parent}->{left_child}->{data} == $node->{data})
        {
            $node->{parent}->{left_child} = $node->{right_child};
        }
        #如果删除的节点是父亲节点的右儿子
        else
        {
            $node->{parent}->{right_child} = $node->{right_child};
        }
    }
    else
    {#被删除的节点既有左儿子，又有右儿子
     
        my $min_right_child = &search_child($node);
        my $child_data = $min_right_child->{data};
        &delete($tree,$child_data);
        $node->{data} = $child_data;
    }
}
1;