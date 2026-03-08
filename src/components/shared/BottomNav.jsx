import { MAROON } from "../../constants/theme";

const tabs = [
  { id: "home",    icon: "🏠", label: "Home"         },
  { id: "tour",    icon: "🎭", label: "Book Tour"    },
  { id: "notif",   icon: "🔔", label: "Notification" },
  { id: "profile", icon: "👤", label: "Profile"      },
];

export default function BottomNav({ active, onNav }) {
  return (
    <div
      style={{
        background: MAROON,
        display: "flex",
        justifyContent: "space-around",
        padding: "10px 0 14px",
      }}
    >
      {tabs.map((t) => (
        <button
          key={t.id}
          onClick={() => onNav(t.id)}
          style={{
            background: "none",
            border: "none",
            cursor: "pointer",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            gap: 2,
            color: active === t.id ? "#FFD700" : "rgba(255,255,255,0.65)",
            fontFamily: "sans-serif",
          }}
        >
          <span style={{ fontSize: 18 }}>{t.icon}</span>
          <span style={{ fontSize: 9, fontWeight: active === t.id ? 700 : 400 }}>
            {t.label}
          </span>
        </button>
      ))}
    </div>
  );
}
