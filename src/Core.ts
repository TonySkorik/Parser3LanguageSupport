'use strict';

export class KeyValuePair<TKey, TValue>{
	Key : TKey;
	Value : TValue;

	public constructor(key : TKey, value: TValue ){
		this.Key = key;
		this.Value = value;
	}
}