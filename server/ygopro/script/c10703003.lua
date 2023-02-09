--战华之鬼·神甘宁
local m=10703003
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEASTWARRIOR),4,5)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,m)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(cm.recon)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_DRAW_COUNT)
    e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,m)
    e5:SetCost(cm.tgcost)
    e5:SetTarget(cm.tgtg)
    e5:SetOperation(cm.tgop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetCountLimit(1,m+1)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(cm.qjcon0)
    e6:SetOperation(cm.qjop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(cm.qjcon)
	e7:SetValue(cm.qjval)
	c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetValue(1)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(cm.qjcon)
	c:RegisterEffect(e8)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(m)
    c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,3,aux.Stringid(m,0))
end

function cm.recon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return rp==tp and re:GetHandler():IsType(TYPE_CONTINUOUS) and re:GetHandler():IsType(TYPE_SPELL) and Duel.GetLP(tp)<8000+2000*c:GetFlagEffectLabel(m)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local num=8000+2000*c:GetFlagEffectLabel(m)
    Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,math.min(2000,num-Duel.GetLP(tp)),REASON_EFFECT)
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.CheckLPCost(tp,2000) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(10703000,0))
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,2000)
end

function cm.costtfilter(c)
	return not c:IsPublic()
end

function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    if Duel.GetMatchingGroupCount(cm.costtfilter,tp,0,0x02,nil)>0 then
        local g=Duel.GetMatchingGroup(cm.costtfilter,tp,0,0x02,nil)
        Duel.ConfirmCards(tp,g)
    end
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,4,PLAYER_ALL,LOCATION_ONFIELD+LOCATION_HAND)
end

function cm.opfdfilter(c)
	return (not c:IsPublic() and c:IsLocation(0x02)) or c:IsFacedown()
end

function cm.opc1filter(c)
	return (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_EQUIP)) and c:IsAbleToGrave()
end

function cm.opcfilter(c)
	return c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_EQUIP)
end

function cm.opmfilter(c)
	return c:IsType(TYPE_MONSTER) and not cm.opcfilter(c) and c:IsAbleToGrave()
end

function cm.opsfilter(c)
	return c:IsType(TYPE_SPELL) and not cm.opcfilter(c) and c:IsAbleToGrave()
end

function cm.optfilter(c)
	return c:IsType(TYPE_TRAP) and not cm.opcfilter(c) and c:IsAbleToGrave()
end

function cm.optgfilter(g,contg,monsg,spelg,trapg)
    local g1=Group.__band(g,contg)
    local g2=Group.__band(g,monsg)
    local g3=Group.__band(g,spelg)
    local g4=Group.__band(g,trapg)
    return #g1==1 and #g2==1 and #g3==1 and #g4==1
end

function cm.oplffilter(c,tp)
    return (not c:IsLocation(0x0e)) and c:GetPreviousControler()==tp
end

function cm.oplf1filter(c)
    return not c:IsLocation(0x0e)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(cm.opfdfilter,tp,0,0x0e,nil)
    Duel.ConfirmCards(tp,g)
	local contg=Duel.GetMatchingGroup(cm.opc1filter,tp,0x0e,0x0e,c)
    local monsg=Duel.GetMatchingGroup(cm.opmfilter,tp,0x0e,0x0e,c)
    local spelg=Duel.GetMatchingGroup(cm.opsfilter,tp,0x0e,0x0e,c)
    local trapg=Duel.GetMatchingGroup(cm.optfilter,tp,0x0e,0x0e,c)
    if not (#contg>0 and #monsg>0 and #spelg>0 and #trapg>0) then return false end
    local gg=Duel.GetFieldGroup(tp,0x0e,0x0e)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local gg1=gg:SelectSubGroup(tp,cm.optgfilter,false,4,4,contg,monsg,spelg,trapg)
    if gg1:GetCount()>0 then
        Duel.HintSelection(gg1)
        Duel.SendtoGrave(gg1,REASON_EFFECT)
        local gg3=gg1:Filter(cm.oplf1filter,nil)
        if gg3:GetCount()>0 then
            local gg2=gg1:FilterCount(cm.oplffilter,nil,tp)
            Duel.BreakEffect()
            if gg2==0 then
                local num=c:GetFlagEffectLabel(m)
                if num==0 then
                    Duel.SetLP(tp,Duel.GetLP(tp)-2000)
                else
                    c:ResetFlagEffect(m)
                    if num==1 then
                        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,num-1)
                    else
                        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,num-1,aux.Stringid(m,4-num))
                    end
                end
            elseif gg2==1 then
                Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	            Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	            Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	            Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	            Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	            local e1=Effect.CreateEffect(c)
	            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	            e1:SetType(EFFECT_TYPE_FIELD)
	            e1:SetCode(EFFECT_CANNOT_BP)
	            e1:SetTargetRange(1,0)
	            e1:SetReset(RESET_PHASE+PHASE_END)
	            Duel.RegisterEffect(e1,tp)
            elseif gg2==3 and Duel.GetLP(tp)<8000+2000*c:GetFlagEffectLabel(m) then
                Duel.Recover(tp,math.min(2000,8000+2000*c:GetFlagEffectLabel(m)-Duel.GetLP(tp)),REASON_EFFECT)
            elseif gg2==4 then
                Duel.Draw(tp,4,REASON_EFFECT)
            end
        end
        Duel.ShuffleHand(1-tp)
    end
end

function cm.qjcon0(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetTurnPlayer()==c:GetControler()
end

function cm.qjop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if (not Duel.IsExistingMatchingCard(aux.TRUE,tp,0x04,0x04,1,c)) or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==1 then
        local e3=Effect.CreateEffect(c)
	    e3:SetType(EFFECT_TYPE_FIELD)
	    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e3:SetCode(EFFECT_DRAW_COUNT)
	    e3:SetTargetRange(0,1)
        e3:SetCondition(cm.ckonfield)
        e3:SetLabelObject(c)
        e3:SetReset(RESET_PHASE+PHASE_END,2)
	    e3:SetValue(2)
	    Duel.RegisterEffect(e3,tp)
        local e1=Effect.CreateEffect(c)
	    e1:SetDescription(aux.Stringid(m,5))
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetTargetRange(LOCATION_HAND,0)
	    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	    e1:SetReset(RESET_PHASE+PHASE_END,2)
        e1:SetLabelObject(c)
        e1:SetCondition(cm.ckonfield)
	    Duel.RegisterEffect(e1,1-tp)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	    Duel.RegisterEffect(e2,1-tp)
        local e0=Effect.CreateEffect(c)
	    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    e0:SetCode(EVENT_PHASE+PHASE_END)
        e0:SetLabel(Duel.GetTurnCount())
        e0:SetLabelObject(c)
        e0:SetCountLimit(1)
        e0:SetCondition(cm.ckturn)
	    e0:SetOperation(cm.ckop)
        e0:SetReset(RESET_PHASE+PHASE_END,2)
	    Duel.RegisterEffect(e0,tp)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x04,0x04,1,1,c)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            local tc=g:GetFirst()
            tc:RegisterFlagEffect(107030030,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(m,6))
            local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetCode(EFFECT_EXTRA_ATTACK)
		    e1:SetValue(1)
            e1:SetCondition(cm.ckonfield)
            e1:SetLabelObject(c)
		    e1:SetReset(RESET_PHASE+PHASE_END,2)
		    tc:RegisterEffect(e1,true)
            local e4=Effect.CreateEffect(c)
            e4:SetDescription(aux.Stringid(m,6))
	        e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	        e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	        e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	        e4:SetRange(LOCATION_MZONE)
            e4:SetLabel(c:GetControler())
            e4:SetLabelObject(c)
            e4:SetCountLimit(1)
            e4:SetCondition(cm.ckat)
	        e4:SetOperation(cm.atop)
            e4:SetReset(RESET_PHASE+PHASE_END,2)
	        tc:RegisterEffect(e4,true)
            local e0=Effect.CreateEffect(c)
	        e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	        e0:SetCode(EVENT_PHASE+PHASE_END)
            e0:SetLabel(Duel.GetTurnCount())
            e0:SetLabelObject(c)
            e0:SetCountLimit(1)
            e0:SetCondition(cm.ckturn)
	        e0:SetOperation(cm.ckop2)
            e0:SetReset(RESET_PHASE+PHASE_END,2)
	        Duel.RegisterEffect(e0,tp)
        end
    end
    c:RegisterFlagEffect(107030031,RESET_PHASE+PHASE_END,0,2)
end

function cm.ckonfield(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():IsOnField()
end

function cm.ckturn(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():IsOnField() and Duel.GetTurnCount()==e:GetLabel()+1
end

function cm.ckop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_SZONE,nil)
    if g then Duel.SendtoHand(g,tp,REASON_EFFECT) end
    Duel.ConfirmCards(1-tp,g)
end

function cm.ckat(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return e:GetLabelObject():IsOnField() and c:IsOnField() and c:IsControler(e:GetLabel()) and Duel.GetTurnPlayer()==1-e:GetLabel()
end

function cm.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsAttackBelow,tp,0,0x04,nil,c:GetAttack())
    if #g>0 then
        Duel.Hint(HINT_CARD,0,m)
        Duel.Destroy(g,REASON_EFFECT)
    end
end

function cm.ckopfilter(c)
    return c:GetFlagEffect(107030030)~=0
end

function cm.ckop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local g=Duel.GetMatchingGroup(cm.ckopfilter,tp,0xff,0xff,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
        tc:ResetFlagEffect(107030030)
    end
end

function cm.qjcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetFlagEffect(107030031)~=0 and Duel.GetTurnPlayer()~=c:GetControler()
end

function cm.qjval(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return 2000*c:GetFlagEffectLabel(m)
end