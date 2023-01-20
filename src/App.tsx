import Roact from "@rbxts/roact";
import { useDispatch, useSelector } from "@rbxts/roact-rodux-hooked";
import { $git } from "rbxts-transform-debug";
import { decrement, increment, selectCounter } from "store";

const GIT_INFO = $git();

export default function App() {
	const dispatch = useDispatch();
	const counter = useSelector(selectCounter);

	return (
		<screengui IgnoreGuiInset ResetOnSpawn={false} ZIndexBehavior="Sibling">
			<textbutton
				Event={{
					Activated: () => {
						dispatch(increment());
					},
					MouseButton2Click: () => {
						dispatch(decrement());
					},
				}}
				Text={`Clicked ${counter} times!\n<font size="14">(${GIT_INFO.LatestTag})</font>`}
				TextSize={20}
				FontFace={Font.fromName("GothamSSm", Enum.FontWeight.Heavy)}
				TextColor3={Color3.fromHex("#FFFFFF")}
				RichText
				BackgroundColor3={Color3.fromHex("#DB2777")}
				AnchorPoint={new Vector2(1, 1)}
				Size={UDim2.fromOffset(220, 80)}
				Position={new UDim2(1, -20, 1, -20)}
			>
				<uicorner CornerRadius={new UDim(0, 8)} />
			</textbutton>
		</screengui>
	);
}
