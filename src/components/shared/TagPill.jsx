import { MAROON, WHITE } from "../../constants/theme";

export default function TagPill({ label, active, onClick }) {
  return (
    <button
      onClick={onClick}
      style={{
        background: active ? MAROON : "#f0f0f0",
        color: active ? WHITE : "#333",
        border: "none",
        borderRadius: 20,
        padding: "5px 14px",
        fontSize: 12,
        cursor: "pointer",
        fontFamily: "sans-serif",
        whiteSpace: "nowrap",
        fontWeight: active ? 700 : 400,
      }}
    >
      {label}
    </button>
  );
}
