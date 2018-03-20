function cle = calc_cle(region1, region2)

if (iscell(region1))
    region1 = region1{1};
end
if (iscell(region2))
    region2 = region2{1};
end

region1 = region_convert(region1, 'polygon');
region2 = region_convert(region2, 'polygon');

x1 = mean(region1(1 : 2 : length(region1)));
y1 = mean(region1(2 : 2 : length(region1)));


x2 = mean(region2(1 : 2 : length(region2)));
y2 = mean(region2(2 : 2 : length(region2)));

cle = distance([x1 y1], [x2 y2]);