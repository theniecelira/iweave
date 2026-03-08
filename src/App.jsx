import { useState } from "react";
import { styles } from "./constants/theme";

// Screens
import SplashScreen            from "./components/screens/SplashScreen";
import HomeScreen              from "./components/screens/HomeScreen";
import ProductsScreen          from "./components/screens/ProductsScreen";
import BagListScreen           from "./components/screens/BagListScreen";
import ProductDetailScreen     from "./components/screens/ProductDetailScreen";
import BookTourScreen          from "./components/screens/BookTourScreen";
import TourDetailScreen        from "./components/screens/TourDetailScreen";
import ItineraryBuilderScreen  from "./components/screens/ItineraryBuilderScreen";
import ProfileScreen           from "./components/screens/ProfileScreen";
import NotificationsScreen     from "./components/screens/NotificationsScreen";

// Shared
import BottomNav from "./components/shared/BottomNav";

export default function App() {
  const [screen,       setScreen]       = useState("splash");
  const [activeTab,    setActiveTab]    = useState("home");
  const [selectedTour, setSelectedTour] = useState(null);
  const [selectedProd, setSelectedProd] = useState(null);

  // ── Tab navigation ────────────────────────────────────────────────────────
  const handleNav = (tab) => {
    setActiveTab(tab);
    const tabToScreen = {
      home:    "home",
      tour:    "tour",
      notif:   "notifications",
      profile: "profile",
    };
    setScreen(tabToScreen[tab] || "home");
  };

  // ── Screen renderers ──────────────────────────────────────────────────────
  const renderScreen = () => {
    switch (screen) {
      case "splash":
        return <SplashScreen onStart={() => { setScreen("home"); setActiveTab("home"); }} />;

      case "home":
        return (
          <HomeScreen
            onNav={handleNav}
            onProduct={(cat) => { setSelectedProd({ category: cat }); setScreen("products"); }}
            onTourDetail={(tour) => { setSelectedTour(tour); setScreen("tourDetail"); }}
          />
        );

      case "products":
        return (
          <ProductsScreen
            category={selectedProd?.category}
            onBack={() => setScreen("home")}
            onBagDetail={(bag) => { setSelectedProd(bag); setScreen("bagList"); }}
          />
        );

      case "bagList":
        return (
          <BagListScreen
            onBack={() => setScreen("products")}
            onBagDetail={(bag) => { setSelectedProd(bag); setScreen("productDetail"); }}
          />
        );

      case "productDetail":
        return (
          <ProductDetailScreen
            product={selectedProd}
            onBack={() => setScreen("bagList")}
          />
        );

      case "tour":
        return (
          <BookTourScreen
            onTourDetail={(tour) => { setSelectedTour(tour); setScreen("tourDetail"); }}
            onItinerary={() => setScreen("itinerary")}
          />
        );

      case "tourDetail":
        return (
          <TourDetailScreen
            tour={selectedTour}
            onBack={() => setScreen("tour")}
            onItinerary={() => setScreen("itinerary")}
          />
        );

      case "itinerary":
        return <ItineraryBuilderScreen onBack={() => setScreen("tour")} />;

      case "notifications":
        return <NotificationsScreen />;

      case "profile":
        return <ProfileScreen />;

      default:
        return <HomeScreen onNav={handleNav} onProduct={() => setScreen("products")} onTourDetail={() => setScreen("tourDetail")} />;
    }
  };

  const showBottomNav = screen !== "splash";

  return (
    <div
      style={{
        minHeight: "100vh",
        background: "linear-gradient(135deg, #1a0a10 0%, #2d1520 100%)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: 20,
        fontFamily: "'Georgia', serif",
      }}
    >
      <div style={styles.phoneFrame}>
        <div style={styles.screen}>
          {renderScreen()}
        </div>
        {showBottomNav && (
          <BottomNav active={activeTab} onNav={handleNav} />
        )}
      </div>
    </div>
  );
}
