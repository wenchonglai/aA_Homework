require "double-linked-list"

describe DoubleLinkedListNode do
  describe "initialize" do
    it "should receive one argument and not raise errors" do 
      expect {DoubleLinkedListNode.new(1)}.not_to raise_error
    end

    it "should correctly handle cases in which " do 
      expect {DoubleLinkedListNode.new()}.not_to raise_error
    end
  end

  context "overall" do
    let(:node1){DoubleLinkedListNode.new(1)}
    let(:node2){DoubleLinkedListNode.new(2)}
    it "should not expose the #prev and #next methods" do
      expect {node2.prev = node1}.to raise_error(NoMethodError)
      expect {node1.head_next = node2}.to raise_error(NoMethodError)
    end
  end
end

describe DoubleLinkedList do
  subject(:list){DoubleLinkedList.new}
  let(:head){list.instance_variable_get(:@head)}
  let(:tail){list.instance_variable_get(:@tail)}

  describe "initialize" do
    it "should have the @head and @tail sentinel nodes" do
      expect(head).not_to be_nil
      expect(tail).not_to be_nil
    end

    it "should initialize @length to 0" do
      expect(list.instance_variable_get(:@length)).to be_zero
    end

    it "should set @head and @tail are connected" do
      expect(head.next).to eq tail
      expect(tail.prev).to eq head
    end
  end

  describe "<<" do
    it "should append a new element before @tail" do
      list << 'some random thing'
      list << 'new_node_val'
      expect(tail.prev.val).to eq "new_node_val"
      expect(list.instance_variable_get(:@length)).to be 2
    end
  end

  describe "unshift" do
    it "should append a new element after @head" do
      list.unshift('some random thing')
      list.unshift('new_node_val_1')
      expect(list.instance_variable_get(:@length)).to be 2
    end
  end

  describe "pop" do
    it "should correctly return the value of the popped node" do
      list << 'some random thing'
      list << 'new_node_val'
      expect(list.pop).to eq 'new_node_val'
      expect(list.instance_variable_get(:@length)).to be 1
    end

    it "should not pop out @head or @tail when the list is empty" do
      list.pop
      list.pop
      expect(list.instance_variable_get(:@tail).prev).to be list.instance_variable_get(:@head)
    end
  end

  describe "shift" do
    it "should correctly return the value of the shifted node" do
      list << 'some random thing'
      list << 'new_node_val'
      expect(list.shift).to eq 'some random thing'
      expect(list.instance_variable_get(:@length)).to be 1
    end

    it "should not shift out @head or @tail when the list is empty" do
      list.shift
      list.shift
      expect(list.instance_variable_get(:@tail).prev).to be list.instance_variable_get(:@head)
    end
  end
end
