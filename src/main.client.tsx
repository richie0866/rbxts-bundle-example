import Roact from "@rbxts/roact";
import { withHookDetection } from "@rbxts/roact-hooked";
import { StoreProvider } from "@rbxts/roact-rodux-hooked";
import { Players } from "@rbxts/services";
import App from "App";
import { configureStore } from "store";

function canAccessCoreGui() {
	return pcall(() => game.GetService("CoreGui").Name !== undefined)[0];
}

withHookDetection(Roact);

const tree = Roact.mount(
	<StoreProvider store={configureStore()}>
		<App />
	</StoreProvider>,
	canAccessCoreGui() ? game.GetService("CoreGui") : Players.LocalPlayer.WaitForChild("PlayerGui"),
	"App",
);

Players.LocalPlayer.CharacterRemoving.Connect(() => {
	Roact.unmount(tree);
});
