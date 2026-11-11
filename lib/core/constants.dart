import 'package:flutter/material.dart';

// ── App Identity ──────────────────────────────────────────────────────────────
const String kAppName = 'KriyaLink';
const String kAppTagline = 'Hubungkan UMKM dengan Kreator Kreatif';
const String kAppVersion = '1.0.0';

// ── API Keys (replace with real values or load from env) ─────────────────────
const String kGeminiApiKey = 'YOUR_GEMINI_API_KEY';
const String kFirebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';

// ── Colors ────────────────────────────────────────────────────────────────────
const Color kPrimaryColor = Color(0xFF167D8D);
const Color kSecondaryColor = Color(0xFF6C63FF);
const Color kBackgroundColor = Color(0xFFFAFAFA);
const Color kSurfaceColor = Color(0xFFFFFFFF);
const Color kErrorColor = Color(0xFFE53935);
const Color kOnPrimaryColor = Color(0xFFFFFFFF);
const Color kTextPrimaryColor = Color(0xFF1A1A2E);
const Color kTextSecondaryColor = Color(0xFF6B7280);
const Color kBorderColor = Color(0xFFE5E7EB);
const Color kSuccessColor = Color(0xFF10B981);
const Color kWarningColor = Color(0xFFF59E0B);

// ── User Roles ────────────────────────────────────────────────────────────────
const String kRoleUmkm = 'umkm';
const String kRoleKreator = 'kreator';

// ── Route Names ───────────────────────────────────────────────────────────────
const String kRouteSplash = '/';
const String kRouteOnboarding = '/onboarding';
const String kRouteHome = '/home';
const String kRouteKreatorDetail = '/kreator-detail';
const String kRouteRequestForm = '/request-form';

// ── Layout ────────────────────────────────────────────────────────────────────
const double kBorderRadiusCard = 16.0;
const double kBorderRadiusButton = 12.0;
const double kBorderRadiusInput = 12.0;
const double kPaddingPage = 20.0;
const double kPaddingCard = 16.0;

// ── Firestore Collections ─────────────────────────────────────────────────────
const String kCollectionUsers = 'users';
const String kCollectionKreators = 'kreators';
const String kCollectionRequests = 'requests';
const String kCollectionPortfolios = 'portfolios';
const String kCollectionReviews = 'reviews';
