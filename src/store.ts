import { Store, createReducer } from "@rbxts/rodux";

interface RootState {
	counter: number;
}

type RootAction = ReturnType<typeof increment | typeof decrement>;

export function increment() {
	return { type: "INCREMENT" } as const;
}

export function decrement() {
	return { type: "DECREMENT" } as const;
}

const initialState: RootState = {
	counter: 0,
};

const rootReducer = createReducer<RootState, RootAction>(initialState, {
	INCREMENT: (state) => {
		return { counter: state.counter + 1 };
	},

	DECREMENT: (state) => {
		return { counter: state.counter - 1 };
	},
});

export function configureStore(initialState?: Partial<RootState>) {
	return new Store(rootReducer, initialState);
}

export const selectCounter = (state: RootState) => state.counter;
