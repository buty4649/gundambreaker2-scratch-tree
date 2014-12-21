#!/usr/bin/env ruby
require 'gviz'
require 'csv'

gv = Gviz.new
tree_data = Hash.new


#tree_data['???'] = {
#    :sym => :unknown,
#    :lnk => [],
#}
#gv.node :unknown, label:'派生先不明', style:'filled', fillcolor:'lightgray'

CSV.foreach('tree.csv') {|row|
    row.pop if row[row.length].nil?
    row.each {|name|
        next if tree_data.key?(name)
        sym = tree_data.length.to_s.to_sym
        tree_data[name] = {:sym => sym, :lnk => []}

        case name
        when /ガンダム/ then
            color = 1
        when /ザク/ then
            color = 2
        when /ゲルググ/ then
            color = 3
        when /ジム|^ジェ/ then
            color = 4
        else
            color = 5
        end

        gv.node sym, label:name.sub(/(.+)\((.*)\)/,"\\1\n\\2")
        gv.node sym, style:'filled', fillcolor:color
    }
    key = row.shift
    tree_data[key][:lnk] = row
}

tree_data.each {|key, value|
    value[:lnk].each{|lnk|
        s = tree_data[key][:sym]
        d = tree_data[lnk][:sym]
        gv.route s => d
    }
}

gv.global layout:'fdp', overlap:false
gv.global label:'ガンブレ2 派生先ツリー @buty4649 2014/12/22 rev.3', fontsize:72
gv.nodes colorscheme:'set310', shape:'box', font:'IPAexゴシック', fontsize:32
gv.save :tree, :png
