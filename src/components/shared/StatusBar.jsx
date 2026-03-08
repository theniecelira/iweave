import { MAROON, WHITE } from "../../constants/theme";

export default function StatusBar() {
  return (
    <div
      style={{
        background: MAROON,
        padding: "8px 20px 4px",
        display: "flex",
        justifyContent: "space-between",
        alignItems: "center",
        color: WHITE,
        fontSize: 11,
        fontFamily: "sans-serif",
      }}
    >
      <span style={{ fontWeight: 700 }}>9:41</span>
      <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
        <span>●●●</span>
        <span>WiFi</span>
        <span>🔋</span>
      </div>
    </div>
  );
}
