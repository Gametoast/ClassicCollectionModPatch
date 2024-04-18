ParticleEmitter("Cracks")
{
	MaxParticles(1, 1);
	StartDelay(0, 0);
	BurstDelay(0.001000, 0.001000);
	BurstCount(1, 1);
	MaxLodDist(1100);
	MinLodDist(1000);
	BoundingRadius(5);
	SoundName("");
	NoRegisterStep();
	Size(1, 1);
	Hue(255, 255);
	Saturation(255, 255);
	Value(255, 255);
	Alpha(255, 255);
	Spawner()
	{
		Spread()
		{
			PositionX(0, 1);
			PositionY(0.033000, 0.033000);
			PositionZ(1.500000, 1.500000);
		}

		Offset()
		{
			PositionX(0, 0);
			PositionY(0.080000, 0.080000);
			PositionZ(0, 0);
		}

		PositionScale(0, 0);
		VelocityScale(0, 0);
		InheritVelocityFactor(0, 0);
		Size(0, 0.100000, 0.100000);
		Hue(0, 0, 0);
		Saturation(0, 0, 0);
		Value(0, 10, 10);
		Alpha(0, 255, 255);
		StartRotation(0, -90, 0);
		RotationVelocity(0, 0, 0);
		FadeInTime(0);
	}

	Transformer()
	{
		LifeTime(1.750000);
		Position()
		{
			LifeTime(0.500000);
		}

		Size(0)
		{
			LifeTime(0.050000);
			Scale(2.500000);
		}

		Color(0)
		{
			LifeTime(1.500000);
			Move(0, 0, 0, 255);
			Next()
			{
				LifeTime(0.500000);
				Move(0, 0, 0, -255);
			}

		}

	}

	Geometry()
	{
		BlendMode("NORMAL");
		Type("BILLBOARD");
		Texture("com_sfx_scorchmark");
	}

	ParticleEmitter("Pebbles")
	{
		MaxParticles(20, 20);
		StartDelay(0, 0);
		BurstDelay(0.001000, 0.001000);
		BurstCount(20, 20);
		MaxLodDist(50);
		MinLodDist(10);
		BoundingRadius(5);
		SoundName("");
		NoRegisterStep();
		Size(1, 1);
		Hue(255, 255);
		Saturation(255, 255);
		Value(255, 255);
		Alpha(255, 255);
		Spawner()
		{
			Circle()
			{
				PositionX(-1, 1);
				PositionY(1, 3);
				PositionZ(-1, 1);
			}

			Offset()
			{
				PositionX(0, 0);
				PositionY(-1, -1);
				PositionZ(0, 0);
			}

			PositionScale(1, 1);
			VelocityScale(1, 5);
			InheritVelocityFactor(0, 0);
			Size(0, 0.002000, 0.004000);
			Hue(0, 0, 20);
			Saturation(0, 20, 80);
			Value(0, 10, 80);
			Alpha(0, 255, 255);
			StartRotation(0, 0, 255);
			RotationVelocity(0, 255, 975);
			FadeInTime(0);
		}

		Transformer()
		{
			LifeTime(2);
			Position()
			{
				LifeTime(2);
				Accelerate(0, -10, 0);
			}

			Size(0)
			{
				LifeTime(0.050000);
				Scale(15);
			}

			Color(0)
			{
				LifeTime(1.500000);
				Move(0, 0, 0, 255);
			}

		}

		Geometry()
		{
			BlendMode("NORMAL");
			Type("PARTICLE");
			Texture("com_sfx_explosion2");
		}

		ParticleEmitter("Smoke")
		{
			MaxParticles(2, 2);
			StartDelay(0, 0);
			BurstDelay(0.050000, 0.050000);
			BurstCount(2, 2);
			MaxLodDist(2100);
			MinLodDist(2000);
			BoundingRadius(30);
			SoundName("");
			Size(1, 1);
			Hue(255, 255);
			Saturation(255, 255);
			Value(255, 255);
			Alpha(255, 255);
			Spawner()
			{
				Spread()
				{
					PositionX(-0.500000, 0.500000);
					PositionY(0.500000, 1);
					PositionZ(-0.500000, 0.500000);
				}

				Offset()
				{
					PositionX(0, 0);
					PositionY(0, 0);
					PositionZ(0, 0);
				}

				PositionScale(0.200000, 0.200000);
				VelocityScale(0.500000, 0.500000);
				InheritVelocityFactor(0, 0);
				Size(0, 0.200000, 0.450000);
				Red(0, 64, 64);
				Green(0, 64, 64);
				Blue(0, 64, 64);
				Alpha(0, 128, 128);
				StartRotation(0, -90, 0);
				RotationVelocity(0, -100, 100);
				FadeInTime(0);
			}

			Transformer()
			{
				LifeTime(3);
				Position()
				{
					LifeTime(3);
					Scale(0);
				}

				Size(0)
				{
					LifeTime(0.500000);
					Scale(3);
				}

				Color(0)
				{
					LifeTime(3);
					Reach(32, 32, 32, 0);
				}

			}

			Geometry()
			{
				BlendMode("NORMAL");
				Type("PARTICLE");
				Texture("com_sfx_smoke3");
			}

			ParticleEmitter("Flare")
			{
				MaxParticles(1, 1);
				StartDelay(0, 0);
				BurstDelay(0.010000, 0.010000);
				BurstCount(1, 1);
				MaxLodDist(2100);
				MinLodDist(2000);
				BoundingRadius(30);
				SoundName("");
				Size(1, 1);
				Hue(255, 255);
				Saturation(255, 255);
				Value(255, 255);
				Alpha(255, 255);
				Spawner()
				{
					Spread()
					{
						PositionX(0, 0);
						PositionY(0, 0);
						PositionZ(0, 0);
					}

					Offset()
					{
						PositionX(0, 0);
						PositionY(0, 0);
						PositionZ(0, 0);
					}

					PositionScale(0, 0);
					VelocityScale(0, 0);
					InheritVelocityFactor(0, 0);
					Size(0, 0.500000, 0.500000);
					Hue(0, 20, 30);
					Saturation(0, 50, 100);
					Value(0, 255, 255);
					Alpha(0, 255, 255);
					StartRotation(0, -90, 0);
					RotationVelocity(0, -100, 100);
					FadeInTime(0);
				}

				Transformer()
				{
					LifeTime(0.100000);
					Position()
					{
						LifeTime(2);
						Scale(0);
					}

					Size(0)
					{
						LifeTime(0.100000);
						Scale(3);
					}

					Color(0)
					{
						LifeTime(0.100000);
						Move(0, 0, 0, -255);
					}

				}

				Geometry()
				{
					BlendMode("ADDITIVE");
					Type("PARTICLE");
					Texture("com_sfx_flashball2");
				}

				ParticleEmitter("Fire")
				{
					MaxParticles(4, 4);
					StartDelay(0, 0);
					BurstDelay(0.010000, 0.010000);
					BurstCount(1, 1);
					MaxLodDist(2100);
					MinLodDist(2000);
					BoundingRadius(5);
					SoundName("");
					Size(1, 1);
					Hue(255, 255);
					Saturation(255, 255);
					Value(255, 255);
					Alpha(255, 255);
					Spawner()
					{
						Spread()
						{
							PositionX(-0.500000, 0.500000);
							PositionY(0.500000, 1);
							PositionZ(-0.500000, 0.500000);
						}

						Offset()
						{
							PositionX(0, 0);
							PositionY(0, 0);
							PositionZ(0, 0);
						}

						PositionScale(0, 0);
						VelocityScale(1, 2);
						InheritVelocityFactor(0, 0);
						Size(0, 0.050000, 0.100000);
						Red(0, 255, 255);
						Green(0, 255, 255);
						Blue(0, 255, 255);
						Alpha(0, 255, 255);
						StartRotation(0, 0, 360);
						RotationVelocity(0, -100, 100);
						FadeInTime(0);
					}

					Transformer()
					{
						LifeTime(0.300000);
						Position()
						{
							LifeTime(0.500000);
							Scale(0);
						}

						Size(0)
						{
							LifeTime(0.300000);
							Scale(5);
						}

						Color(0)
						{
							LifeTime(0.100000);
							Reach(255, 255, 255, 255);
							Next()
							{
								LifeTime(0.200000);
								Reach(255, 255, 255, 0);
							}

						}

					}

					Geometry()
					{
						BlendMode("ADDITIVE");
						Type("PARTICLE");
						Texture("com_sfx_explosion4");
					}

				}

			}

		}

	}

}

