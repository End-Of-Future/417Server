--机怪操使
function c3654000.initial_effect(c) 
	c:SetSPSummonOnce(3654000)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FLIP),1,1)
	c:SetUniqueOnField(1,0,3654000)
	--
	c:EnableReviveLimit()
	--cannot be link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0) 
	--to hand and sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(c3654000.tstg) 
	e1:SetOperation(c3654000.tsop) 
	c:RegisterEffect(e1) 
	--pos 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(3654000,1))
	e2:SetCategory(CATEGORY_POSITION) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c3654000.postg) 
	e2:SetOperation(c3654000.posop) 
	c:RegisterEffect(e2) 
	--replace
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(3654000,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c3654000.condition1) 
	e3:SetTarget(c3654000.target1)
	e3:SetOperation(c3654000.operation1)
	c:RegisterEffect(e3) 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(3654000,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_FLIP) end) 
	e3:SetTarget(c3654000.target2)
	e3:SetOperation(c3654000.operation2)
	c:RegisterEffect(e3)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c3654000.reptg)
	c:RegisterEffect(e3)
end 
function c3654000.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x104)   
end 
function c3654000.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3654000.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c3654000.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsSetCard(0x104) and c:IsLevel(2) 
end 
function c3654000.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c3654000.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(c3654000.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(3654000,0)) then 
			local sg=Duel.SelectMatchingCard(tp,c3654000.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then 
				Duel.ConfirmCards(1-tp,sg) 
			end  
		end 
	end 
end 
function c3654000.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end 
function c3654000.posop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		if tc:IsFaceup() then 
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		elseif tc:IsFacedown() then 
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end 
	end 
end 
function c3654000.condition1(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return rp==1-tp and tc:IsControler(tp) and tc:IsOnField() and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_FLIP)
end
function c3654000.filter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function c3654000.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,3654000)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end 
	if chk==0 then return Duel.IsExistingTarget(c3654000.filter,tp,LOCATION_MZONE,0,1,e:GetLabelObject(),ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c3654000.filter,tp,LOCATION_MZONE,0,1,1,e:GetLabelObject(),ct)
	local val=ct+bit.lshift(ev+1,16)
	if label then
		Duel.SetFlagEffectLabel(0,3654000,val)
	else
		Duel.RegisterFlagEffect(0,3654000,RESET_CHAIN,0,1,val)
	end
end
function c3654000.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
function c3654000.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(0)
	local ad=Group.FromCards(a,d)  
	local bc=Duel.GetAttackTarget()
	if chk==0 then return bc and bc:IsControler(tp) and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,1,ad) end 
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,ad) 
end
function c3654000.operation2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local a=Duel.GetAttacker() 
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and a:IsAttackable() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,tc) 
	end
end
function c3654000.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_FLIP) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_FLIP) 
		Duel.Destroy(dg,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end


