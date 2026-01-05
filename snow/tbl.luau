export type function partial(tbl: type)
	assert(tbl:is("table"), "partial can only be applied to tables")
	local new = types.newtable()

	for k, v in tbl:properties() do
		local read = assert(v.read, "properties cannot be write-only")
		new:setreadproperty(k, types.optional(read))
	end

	new:setindexer(types.any, types.never)
	return new
end

local function write<T>(tbl: T, write: partial<T>): T
	local result: any = table.clone(tbl :: any)

	for k, v in write :: { [any]: any } do
		result[k] = v
	end

	return table.freeze(result :: any)
end

export type function merge(tbla: type, tblb: type)
	assert(tbla:is("table"), "merge can only be applied to tables")
	assert(tblb:is("table"), "merge can only be applied to tables")
	local new = types.newtable()

	for k, v in tbla:properties() do
		local read = assert(v.read, "properties cannot be write-only")
		new:setreadproperty(k, read)
	end

	for k, v in tblb:properties() do
		local read = assert(v.read, "properties cannot be write-only")
		new:setreadproperty(k, read)
	end

	return new
end

local function merge<T, U>(tbla: T, tblb: U): merge<T, U>
	local result: any = table.clone(tbla :: any)

	for k, v in tblb :: { [any]: any } do
		result[k] = v
	end

	return table.freeze(result :: any)
end

export type function omit(tbl: type, key: type)
	assert(tbl:is("table"), "omit can only be applied to tables")
	tbl:setproperty(key)
	return tbl
end

local function omit<T, K>(tbl: T, key: K | ""): omit<T, K>
	local result = table.clone(tbl :: any)
	result[key] = nil
	return table.freeze(result :: any)
end

export type function with(tbl: type, key: type, value: type)
	assert(tbl:is("table"), "with can only be applied to tables")
	local tbl = types.copy(tbl)
	tbl:setreadproperty(key, value)
	return tbl
end

local function with<T, K, V>(tbl: T, key: K | "", value: V): with<T, K, V>
	local result = table.clone(tbl :: any)
	result[key] = value
	return table.freeze(result :: any)
end

local function set<T, K>(tbl: T, key: K & keyof<T>, value: index<T, K>): T
	local result: any = table.clone(tbl :: any)
	result[key] = value
	return table.freeze(result :: any)
end

return {
	write = write,
	merge = merge,
	omit = omit,
	with = with,
	set = set,
}
