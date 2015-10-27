class Msg < ActiveRecord::Base
	def created_at 
      super.strftime('%Y-%m-%d %H:%M:%S') if super
    end 

    def self.allow_pub item
    	Msg.create({
    		:content=>"恭喜你，你发布的：【#{item.title}】 通过了审核！",
    		:from_typcd=>'SYS',
    		:to_id=>item.mem.id,
    		:to_typcd=>'MEM'
    	})
    end

    def self.reject_pub item,reson
    	Msg.create({
    		:content=>"对不起，你发布的：【#{item.title}】 没有通过审核，已被管理员删除！",
    		:from_typcd=>'SYS',
    		:to_id=>item.mem.id,
    		:to_typcd=>'MEM',
            :extra =>reson
    	})
    end
    def self.allow_pcon item
        Msg.create({
            :content=>"恭喜你，你为【#{item.plugin.title}】填加的使用方法通过了审核，请查看积分记录！",
            :from_typcd=>'SYS',
            :to_id=>item.mem.id,
            :to_typcd=>'MEM'
        })
    end

    def self.reject_pcon item
        Msg.create({
            :content=>"对不起，你为【#{item.plugin.title}】填加的使用方法没有通过审核，已被管理员删除！",
            :from_typcd=>'SYS',
            :to_id=>item.mem.id,
            :to_typcd=>'MEM'
        })
    end

    def self.send_to_mem mem_id,con
        Msg.create({
            :content=>con,
            :from_typcd=>'SYS',
            :to_id=> mem_id.to_i,
            :to_typcd=>'MEM', 
        })
    end
end
