@tool
class_name  ObjectUtils

static func copyBean(soure:Dictionary,target:Object):
	for key in soure.keys():
		if target.has_method("set_"+key) or key in target:
			target.set(key,soure[key])

static func dict_2_inst(d:Dictionary):
	for i in d.keys():
		if d[i] is Dictionary:
			d[i]=dict_2_inst(d[i])
	if d.has("@path"):
		return dict_to_inst(d)
	else :
		return d;

static func inst_2_dict(obj:Object)->Dictionary:
	return dict_convert(inst_to_dict(obj).duplicate(true))

static func dict_convert(d:Dictionary)->Dictionary:
	for key in d.keys():
		if d[key] is Dictionary:
			d[key]=dict_convert(d[key])
		elif d[key] is Object:
			d[key]=dict_convert(inst_to_dict(d[key]))
	return d;

# 权重选择器
# d{数据:权重值}
static func weight_selector(d:Dictionary,size:int=1):
	var total=d.values().reduce(func(accum, number): return accum + number, 0)
	var re=[]
	for i in size:
		var temp=0;
		var value=randi_range(0,total)
		for key in d:
			temp+=d[key]
			if value<=temp:
				re.append(key)
				break
	return re;
