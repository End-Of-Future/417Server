--废墟兵械 三角龙
function c88881734.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88881734)
	e1:SetTarget(c88881734.tg)
	e1:SetOperation(c88881734.op)
	c:RegisterEffect(e1)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88881734.atkcon)
	e2:SetValue(c88881734.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c88881734.efcon)
	e3:SetTarget(c88881734.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCountLimit(1,88881735)
	e4:SetCondition(c88881734.drcon)
	e4:SetTarget(c88881734.drtg)
	e4:SetOperation(c88881734.drop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCondition(c88881734.efcon)
	e5:SetTarget(c88881734.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c88881734.filter(c,e)
	return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c88881734.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (Duel.IsExistingMatchingCard(c88881734.filter,tp,LOCATION_MZONE,0,1,nil,e) or (Duel.IsExistingMatchingCard(c88881734.filter,tp,LOCATION_GRAVE,0,1,nil,e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c88881734.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c88881734.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c88881734.filter,tp,LOCATION_MZONE,0,1,1,nil,e)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	end
	end
end
function c88881734.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and not c:IsOriginalCodeRule(88881734)
end
function c88881734.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==e:GetHandler():GetEquipTarget():GetEquipGroup():Filter(Card.IsCode,nil,88881734):GetFirst()
end
function c88881734.atkval(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBaseAttack()
end
function c88881734.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(c88881734.eqfilter,1,nil)
end
function c88881734.eqfilter(c)
	return c:IsOriginalCodeRule(88881734)
end
function c88881734.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipGroup():IsExists(c88881734.eqfilter,1,nil) and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c88881734.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88881734.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end