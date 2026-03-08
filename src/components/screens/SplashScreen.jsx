import { MAROON, WHITE } from "../../constants/theme";

export default function SplashScreen({ onStart }) {
  return (
    <div
      style={{
        flex: 1,
        position: "relative",
        overflow: "hidden",
        display: "flex",
        flexDirection: "column",
      }}
    >
      {/* Full-bleed background photo of weavers */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          backgroundImage:
            "url('https://images.unsplash.com/photo-1558618047-f4e0e5e924e4?w=600&q=80')",
          backgroundSize: "cover",
          backgroundPosition: "center top",
        }}
      />

      {/* Maroon gradient overlay — stronger at bottom */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          background: `linear-gradient(
            to bottom,
            rgba(122,21,48,0.30) 0%,
            rgba(122,21,48,0.45) 40%,
            rgba(122,21,48,0.80) 65%,
            rgba(122,21,48,1.00) 100%
          )`,
        }}
      />

      {/* Content pinned to bottom */}
      <div
        style={{
          position: "relative",
          zIndex: 1,
          marginTop: "auto",
          padding: "0 28px 44px",
        }}
      >
        {/* Tagline */}
        <div style={{ marginBottom: 28 }}>
          {["Woven.", "Experiences.", "Connections."].map((line) => (
            <div
              key={line}
              style={{
                color: WHITE,
                fontSize: 36,
                fontWeight: 900,
                lineHeight: 1.15,
                fontFamily: "'Georgia', serif",
                textShadow: "0 2px 12px rgba(0,0,0,0.35)",
              }}
            >
              {line}
            </div>
          ))}
        </div>

        {/* CTA Button */}
        <button
          onClick={onStart}
          style={{
            background: WHITE,
            color: MAROON,
            border: "none",
            borderRadius: 30,
            padding: "14px 0",
            width: "100%",
            fontFamily: "sans-serif",
            fontWeight: 700,
            fontSize: 15,
            cursor: "pointer",
            boxShadow: "0 4px 24px rgba(0,0,0,0.25)",
            letterSpacing: 0.3,
          }}
        >
          Start Weaving
        </button>
      </div>
    </div>
  );
}
