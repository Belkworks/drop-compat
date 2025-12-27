local function noop() end

return {
	apierror = noop :: (data: {
		msg: string,
		op: "GetAsync" | "SetAsync" | "UpdateAsync" | "RemoveAsync",
		datastore: DataStore,
		key: string,
		retry: boolean,
	}) -> (),
}