module GChart
	#
	#  GChart.radar(){} #=> type is "r"
	#  GChart.radar(:curve){} #=> type is "rs"
	#
	#  OR
	#
	#  GChart.radar do |r|
	#    r.curve = true
	#  end
	#
	class Radar < Base
		attr_writer :curve

		def curved?; @curve end

		def initialize *args, &blk
			# get :curve option
			option = {}
			args.select{|v|Symbol==v}.each{|v| option[v]=true}
			arg_option = Hash === args[-1] ? args[-1] : {}
			option.merge! arg_option

			super option, &blk
		end

    def render_chart_type #:nodoc:
      "r" + @curve ? "s" : ""
    end
  end

end
