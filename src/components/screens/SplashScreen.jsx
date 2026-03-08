import { MAROON, WHITE, ORANGE } from "../../constants/theme";

export default function SplashScreen({ onStart }) {
  return (
    <div
      style={{
        flex: 1,
        background: MAROON,
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        gap: 20,
        position: "relative",
        overflow: "hidden",
      }}
    >
      {/* Background texture */}
      <div
        style={{
          position: "absolute",
          inset: 0,
          backgroundImage:
            "url('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400')",
          backgroundSize: "cover",
          backgroundPosition: "center",
          opacity: 0.15,
        }}
      />

      <div
        style={{
          zIndex: 1,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          gap: 16,
        }}
      >
        {/* Logo */}
        <div
          style={{
            width: 140,
            height: 140,
            borderRadius: "50%",
            background: "#1a0a10",
            border: `4px solid rgba(255,255,255,0.2)`,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            overflow: "hidden",
            position: "relative",
          }}
        >
          {[
            "#FF6B35","#4CAF50","#E91E63","#2196F3","#FFC107",
            "#9C27B0","#795548","#607D8B","#F44336","#00BCD4",
            "#8BC34A","#FF5722",
          ].map((color, i) => (
            <div
              key={i}
              style={{
                position: "absolute",
                width: `${20 + Math.random() * 40}px`,
                height: 6,
                background: color,
                borderRadius: 3,
                top: `${10 + i * 8}%`,
                left: `${5 + (i % 3) * 30}%`,
                transform: `rotate(${i % 2 === 0 ? 0 : 45}deg)`,
              }}
            />
          ))}
          <div
            style={{
              position: "absolute",
              bottom: 20,
              left: 0,
              right: 0,
              textAlign: "center",
            }}
          >
            <div
              style={{
                color: WHITE,
                fontSize: 18,
                fontFamily: "'Georgia', serif",
                fontStyle: "italic",
                textShadow: "0 1px 4px rgba(0,0,0,0.8)",
              }}
            >
              iWeave
            </div>
            <div
              style={{
                color: "rgba(255,255,255,0.7)",
                fontSize: 9,
                fontFamily: "sans-serif",
              }}
            >
              Est. 2024
            </div>
          </div>
        </div>

        {/* Tagline */}
        <div style={{ textAlign: "center" }}>
          {["Woven.", "Experiences.", "Connections."].map((line) => (
            <div
              key={line}
              style={{
                color: WHITE,
                fontSize: 32,
                fontWeight: 900,
                lineHeight: 1.1,
                fontFamily: "'Georgia', serif",
              }}
            >
              {line}
            </div>
          ))}
        </div>

        <p
          style={{
            color: "rgba(255,255,255,0.75)",
            fontSize: 12,
            textAlign: "center",
            fontFamily: "sans-serif",
            maxWidth: 220,
          }}
        >
          Crafting Unforgettable Experiences, One Tikog at A Time!
        </p>

        <button
          onClick={onStart}
          style={{
            background: WHITE,
            color: MAROON,
            border: "none",
            borderRadius: 30,
            padding: "12px 40px",
            fontFamily: "sans-serif",
            fontWeight: 700,
            fontSize: 14,
            cursor: "pointer",
            marginTop: 10,
            boxShadow: "0 4px 20px rgba(0,0,0,0.3)",
          }}
        >
          Start Weaving
        </button>
      </div>
    </div>
  );
}
