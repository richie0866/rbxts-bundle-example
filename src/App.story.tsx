import Roact from "@rbxts/roact";
import { withHookDetection } from "@rbxts/roact-hooked";
import { StoreProvider } from "@rbxts/roact-rodux-hooked";
import App from "App";
import { configureStore } from "store";

export = (target: Frame) => {
	withHookDetection(Roact);

	const tree = Roact.mount(
		<StoreProvider store={configureStore()}>
			<App />
		</StoreProvider>,
		target,
		"App",
	);

	return () => {
		Roact.unmount(tree);
	};
};
