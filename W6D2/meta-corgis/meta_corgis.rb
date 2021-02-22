class SnackBox
  SNACK_BOX_DATA = {
    1 => {
      "bone" => {
        "info" => "Phoenician rawhide",
        "tastiness" => 20
      },
      "kibble" => {
        "info" => "Delicately braised hamhocks",
        "tastiness" => 33
      },
      "treat" => {
        "info" => "Chewy dental sticks",
        "tastiness" => 40
      }
    },
    2 => {
      "bone" => {
        "info" => "An old dirty bone",
        "tastiness" => 2
      },
      "kibble" => {
        "info" => "Kale clusters",
        "tastiness" => 1
      },
      "treat" => {
        "info" => "Bacon",
        "tastiness" => 80
      }
    },
    3 => {
      "bone" => {
        "info" => "A steak bone",
        "tastiness" => 64
      },
      "kibble" => {
        "info" => "Sweet Potato nibbles",
        "tastiness" => 45
      },
      "treat" => {
        "info" => "Chicken bits",
        "tastiness" => 75
      }
    }
  }
  def initialize(data = SNACK_BOX_DATA)
    @data = data
  end

  def get_bone_info(box_id)
    @data[box_id]["bone"]["info"]
  end

  def get_bone_tastiness(box_id)
    @data[box_id]["bone"]["tastiness"]
  end

  def get_kibble_info(box_id)
    @data[box_id]["kibble"]["info"]
  end

  def get_kibble_tastiness(box_id)
    @data[box_id]["kibble"]["tastiness"]
  end

  def get_treat_info(box_id)
    @data[box_id]["treat"]["info"]
  end

  def get_treat_tastiness(box_id)
    @data[box_id]["treat"]["tastiness"]
  end
end

class CorgiSnacks

  def initialize(snack_box, box_id)
    @snack_box = snack_box
    @box_id = box_id
  end

  def bone
    info = self.get_bone_info(@box_id)
    tastiness = self.get_bone_tastiness(@box_id)
    result = "Bone: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

  def kibble
    info = self.get_kibble_info(@box_id)
    tastiness = self.get_kibble_tastiness(@box_id)
    result = "Kibble: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

  def treat
    info = self.get_treat_info(@box_id)
    tastiness = self.get_treat_tastiness(@box_id)
    result = "Treat: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end
end


class MetaCorgiSnacks
  def initialize(snack_box, box_id)
    @snack_box = snack_box
    @box_id = box_id
  end

  # def method_missing(method_name, *args)
  #   if [:bone, :kibble, :treat].include?(method_name) 
  #     info = @snack_box.send("get_#{method_name}_info", @box_id)
  #     tastiness = @snack_box.send("get_#{method_name}_tastiness", @box_id)
  #     result = "Treat: #{info}: #{tastiness} "
  #     tastiness > 30 ? "* #{result}" : result
  #   end
  # end

  def self.define_snack(method_name)
    # Your code goes here...
    define_method(method_name){
      info = @snack_box.send("get_#{method_name}_info", @box_id)
      tastiness = @snack_box.send("get_#{method_name}_tastiness", @box_id)
      result = "Treat: #{info}: #{tastiness} "
      tastiness > 30 ? "* #{result}" : result
    }
  end

  define_snack(:bone)
  define_snack(:kibble)
  define_snack(:treat)
end

if __FILE__ == $PROGRAM_NAME
  meta_snacks = MetaCorgiSnacks.new(SnackBox.new, 1)
  p meta_snacks.bone
  p meta_snacks.kibble
end