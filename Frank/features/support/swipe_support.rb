def swipeIndDirection(uiquery, direction)
    views_touched = frankly_map( uiquery, 'swipeInDirection:',"#{direction}"   )
    raise "could not find anything matching [#{uiquery}] to touch" if views_touched.empty?
end

# When /^I swipe "([^\"]*)" the "([^\"]*)"$/ do |direction,mark|
#     swipeIndDirection("view marked:'#{mark}'", direction)
#     sleep 1
# end

class CGPoint
    attr_accessor :x
    attr_accessor :y
    
    def initialize(xCoord, yCoord)
        @x = xCoord
        @y = yCoord
    end
    
    def stringValue
        "{" << "#{x}" << "," << "#{y}" <<"}"
    end
end


def swipeAt(uiquery, point, direction)
    views_touched = frankly_map( uiquery, 'swipeAt:direction:', point.stringValue,"#{direction}"   )
    raise "could not find anything matching [#{uiquery}] to touch" if
    views_touched.empty?
end

# When /^I swipe "([^\"]*)" the "([^\"]*)" at (\d+) and (\d+)$/ do |direction,mark,pointx,pointy|
#     pointx = pointx.to_i
#     pointy = pointy.to_i
#     point = CGPoint.new("#{pointx}", "#{pointy}")
#     swipeAt("view marked:'#{mark}'", point, direction)
# end