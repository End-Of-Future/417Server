--孤掷一注的抽卡！YADAZE!
local m=30655560
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DRAW)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,30655560)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(30655560,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(30655560,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(30655560)~=0 end
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter1(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and c:IsRankBelow(13)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
			Duel.IsPlayerCanSpecialSummonCount(tp,2) and
			aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) and
			Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_SPELL)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local turnp=Duel.GetTurnPlayer()
			local ph=Duel.GetCurrentPhase()
	local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if tc1 and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if not aux.MustMaterialCheck(tc1,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		local m=_G["c"..tc1:GetCode()]
		if not m then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1,m.xyz_number)
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
			tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:CompleteProcedure()
			if ph==PHASE_DRAW then
				Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,turnp)
			end
			if ph==PHASE_STANDBY then
				Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,turnp)
			end
			if ph==PHASE_MAIN1 then
				Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,turnp)
			end
			if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
				Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			end
			if ph==PHASE_MAIN2 then
				Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			end
		end
	end
end
