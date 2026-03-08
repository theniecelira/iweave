import { MAROON, WHITE } from "../../constants/theme";

export default function SearchBar({ placeholder = "Search here ...", bg = WHITE }) {
  return (
    <div style={{ background: MAROON, padding: "6px 16px 10px" }}>
      <div
        style={{
          background: bg,
          borderRadius: 20,
          padding: "8px 14px",
          display: "flex",
          alignItems: "center",
          gap: 8,
          fontFamily: "sans-serif",
        }}
      >
        <span style={{ fontSize: 14 }}>☰</span>
        <input
          placeholder={placeholder}
          style={{
            flex: 1,
            border: "none",
            outline: "none",
            fontSize: 13,
            background: "transparent",
            color: "#333",
          }}
        />
        <span style={{ fontSize: 14, color: "#666" }}>🔍</span>
      </div>
    </div>
  );
}
