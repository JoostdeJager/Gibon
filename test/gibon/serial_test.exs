defmodule Gibon.SerialTest do
  use Gibon.DataCase

  alias Gibon.Serial

  describe "devices" do
    alias Gibon.Serial.Device

    @valid_attrs %{port: "some port", product_id: 42}
    @update_attrs %{port: "some updated port", product_id: 43}
    @invalid_attrs %{port: nil, product_id: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Serial.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Serial.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Serial.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = Serial.create_device(@valid_attrs)
      assert device.port == "some port"
      assert device.product_id == 42
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Serial.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = Serial.update_device(device, @update_attrs)
      assert device.port == "some updated port"
      assert device.product_id == 43
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Serial.update_device(device, @invalid_attrs)
      assert device == Serial.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Serial.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Serial.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Serial.change_device(device)
    end
  end

  describe "conditions" do
    alias Gibon.Serial.Condition

    @valid_attrs %{operator: "some operator", value: "some value"}
    @update_attrs %{operator: "some updated operator", value: "some updated value"}
    @invalid_attrs %{operator: nil, value: nil}

    def condition_fixture(attrs \\ %{}) do
      {:ok, condition} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Serial.create_condition()

      condition
    end

    test "list_conditions/0 returns all conditions" do
      condition = condition_fixture()
      assert Serial.list_conditions() == [condition]
    end

    test "get_condition!/1 returns the condition with given id" do
      condition = condition_fixture()
      assert Serial.get_condition!(condition.id) == condition
    end

    test "create_condition/1 with valid data creates a condition" do
      assert {:ok, %Condition{} = condition} = Serial.create_condition(@valid_attrs)
      assert condition.operator == "some operator"
      assert condition.value == "some value"
    end

    test "create_condition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Serial.create_condition(@invalid_attrs)
    end

    test "update_condition/2 with valid data updates the condition" do
      condition = condition_fixture()
      assert {:ok, %Condition{} = condition} = Serial.update_condition(condition, @update_attrs)
      assert condition.operator == "some updated operator"
      assert condition.value == "some updated value"
    end

    test "update_condition/2 with invalid data returns error changeset" do
      condition = condition_fixture()
      assert {:error, %Ecto.Changeset{}} = Serial.update_condition(condition, @invalid_attrs)
      assert condition == Serial.get_condition!(condition.id)
    end

    test "delete_condition/1 deletes the condition" do
      condition = condition_fixture()
      assert {:ok, %Condition{}} = Serial.delete_condition(condition)
      assert_raise Ecto.NoResultsError, fn -> Serial.get_condition!(condition.id) end
    end

    test "change_condition/1 returns a condition changeset" do
      condition = condition_fixture()
      assert %Ecto.Changeset{} = Serial.change_condition(condition)
    end
  end

  describe "configs" do
    alias Gibon.Serial.Config

    @valid_attrs %{request_port: "some request_port", request_url: "some request_url"}
    @update_attrs %{request_port: "some updated request_port", request_url: "some updated request_url"}
    @invalid_attrs %{request_port: nil, request_url: nil}

    def config_fixture(attrs \\ %{}) do
      {:ok, config} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Serial.create_config()

      config
    end

    test "list_configs/0 returns all configs" do
      config = config_fixture()
      assert Serial.list_configs() == [config]
    end

    test "get_config!/1 returns the config with given id" do
      config = config_fixture()
      assert Serial.get_config!(config.id) == config
    end

    test "create_config/1 with valid data creates a config" do
      assert {:ok, %Config{} = config} = Serial.create_config(@valid_attrs)
      assert config.request_port == "some request_port"
      assert config.request_url == "some request_url"
    end

    test "create_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Serial.create_config(@invalid_attrs)
    end

    test "update_config/2 with valid data updates the config" do
      config = config_fixture()
      assert {:ok, %Config{} = config} = Serial.update_config(config, @update_attrs)
      assert config.request_port == "some updated request_port"
      assert config.request_url == "some updated request_url"
    end

    test "update_config/2 with invalid data returns error changeset" do
      config = config_fixture()
      assert {:error, %Ecto.Changeset{}} = Serial.update_config(config, @invalid_attrs)
      assert config == Serial.get_config!(config.id)
    end

    test "delete_config/1 deletes the config" do
      config = config_fixture()
      assert {:ok, %Config{}} = Serial.delete_config(config)
      assert_raise Ecto.NoResultsError, fn -> Serial.get_config!(config.id) end
    end

    test "change_config/1 returns a config changeset" do
      config = config_fixture()
      assert %Ecto.Changeset{} = Serial.change_config(config)
    end
  end
end
