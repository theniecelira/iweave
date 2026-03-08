import { MAROON, WHITE } from "../../constants/theme";
import StatusBar from "../shared/StatusBar";

export default function NotificationsScreen() {
  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", background: "#fff" }}>
      <StatusBar />

      {/* Header */}
      <div style={{ background: MAROON, padding: "12px 16px" }}>
        <h2 style={{ color: WHITE, fontSize: 16, fontFamily: "'Georgia', serif", margin: 0 }}>
          Notifications
        </h2>
      </div>

      {/* Empty state */}
      <div
        style={{
          flex: 1,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          gap: 12,
          padding: 32,
        }}
      >
        <div style={{ fontSize: 56 }}>🔔</div>
        <h3 style={{ fontFamily: "sans-serif", fontSize: 15, color: "#333", margin: 0 }}>
          No notifications yet
        </h3>
        <p style={{ fontFamily: "sans-serif", fontSize: 12, color: "#888", textAlign: "center", margin: 0, lineHeight: 1.5 }}>
          When you book tours, purchase products, or receive updates from iWeave, they'll appear here.
        </p>
      </div>
    </div>
  );
}
